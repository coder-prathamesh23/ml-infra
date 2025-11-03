locals {
  prefix = "${var.env}-mlops"
}

# ----------------------------
# VPC module
# ----------------------------
module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = var.vpc_name
  env             = var.env
  cidr_block      = var.cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

# ----------------------------
# S3 module
# ----------------------------
module "s3" {
  source               = "./modules/s3"
  artifact_bucket_name = var.artifact_bucket_name
}

# ----------------------------
# IAM module
# ----------------------------
module "iam" {
  source        = "./modules/iam"
  env           = var.env
  s3_bucket_arn = module.s3.bucket_arn
  kms_key_arn   = module.s3.kms_key_arn
}

# ----------------------------
# SageMaker module
# ----------------------------
module "sagemaker" {
  source                       = "./modules/sagemaker"
  execution_role_arn           = module.iam.sagemaker_execution_role_arn
  vpc_id                       = module.vpc.vpc_id
  subnet_ids                   = module.vpc.private_subnet_ids
  domain_name                  = var.sagemaker_domain_name
  mvp_model_package_group_name = var.mvp_model_package_group_name
  pipeline_description         = var.pipeline_description
  pipeline_name                = var.pipeline_name
  pipeline_display_name        = var.pipeline_display_name
  security_group_ids           = var.security_group_ids
}

# ----------------------------
# Lambda (root stack) - package using archive provider
# ----------------------------
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./lambda/sagemaker_model_approval_lambda.py"
  output_path = "./lambda/sagemaker_model_approval_lambda.zip"
}


# ------------------------------------------------------------------------------
# IAM Role for Lambda Execution
# ------------------------------------------------------------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name = "sagemaker-model-approval-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# The IAM Policy for the Lambda function
resource "aws_iam_policy" "lambda_policy" {
  name        = "sagemaker-model-approval-lambda-policy"
  description = "Policy for Lambda to manage SageMaker Model Packages and Endpoints"

  policy = templatefile("lambda/lambda_iam_policy.json", {
    sagemaker_execution_role_arn = var.sagemaker_execution_role_arn
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


resource "aws_lambda_function" "sagemaker_approval_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "SageMakerModelApprovalLambda"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "sagemaker_model_approval_lambda.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.11"
  timeout          = 60 # Set a reasonable timeout

  environment {
    variables = {
      # This is the role that SageMaker will assume to create the Model/Endpoint
      SAGEMAKER_EXECUTION_ROLE = var.sagemaker_execution_role_arn
      ACCURACY_THRESHOLD       = var.accuracy_threshold
      DEFAULT_ENDPOINT_NAME    = var.default_endpoint_name
      INFERENCE_INSTANCE_TYPE  = var.inference_instance_type
    }
  }
}
# ----------------------------
# EventBridge rule to catch SageMaker Model Package state changes
# ----------------------------
resource "aws_cloudwatch_event_rule" "sagemaker_model_package_event" {
  name        = "sagemaker-model-package-approval-rule"
  description = "Triggers Lambda when a SageMaker Model Package status changes to PendingManualApproval"

  event_pattern = jsonencode({
    "source" : ["aws.sagemaker"],
    "detail-type" : ["SageMaker Model Package State Change"],
    "detail" : {
      "ModelPackageGroupArn" : [{
        "exists" : true
      }],
      "ModelPackageStatus" : ["PendingManualApproval"]
    }
  })
}


resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.sagemaker_model_package_event.name
  arn  = aws_lambda_function.sagemaker_approval_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sagemaker_approval_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sagemaker_model_package_event.arn
}

