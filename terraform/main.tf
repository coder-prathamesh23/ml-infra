locals {
  prefix = "${var.env}-mlops"
}

# ----------------------------
# VPC module
# ----------------------------
module "vpc" {
  source               = "./modules/vpc"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  use_existing_vpc     = var.use_existing_vpc
  existing_vpc_id      = var.existing_vpc_id
  existing_subnet_ids  = var.existing_subnet_ids
}

# ----------------------------
# S3 module
# ----------------------------
module "s3" {
  source = "./modules/s3"
  env    = var.env
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
  source                  = "./modules/sagemaker"
  env                     = var.env
  execution_role_arn      = module.iam.sagemaker_execution_role_arn
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnet_ids
  domain_name             = var.sagemaker_domain_name
  model_package_group_name = var.model_package_group_name
}

# ----------------------------
# Lambda (root stack) - package using archive provider
# ----------------------------
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda/deploy_lambda.zip"
}

resource "aws_lambda_function" "deploy_model" {
  function_name = "${local.prefix}-deploy-approved-model"
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "deploy_lambda.lambda_handler"
  runtime       = "python3.10"
  role          = module.iam.lambda_role_arn
  timeout       = 900

  environment {
    variables = {
      SAGEMAKER_EXECUTION_ROLE = module.iam.sagemaker_execution_role_arn
      S3_BUCKET                = module.s3.bucket
      MODEL_PACKAGE_GROUP_NAME = module.sagemaker.model_package_group_name
      ACCURACY_THRESHOLD       = "0.80"
      DEFAULT_ENDPOINT_NAME    = "${local.prefix}-endpoint"
    }
  }

  # Optionally limit concurrency for safety
  # reserved_concurrent_executions = 2
}

# ----------------------------
# EventBridge rule to catch SageMaker Model Package state changes
# ----------------------------
resource "aws_cloudwatch_event_rule" "sagemaker_model_package_change" {
  name        = "${local.prefix}-sagemaker-model-package-change"
  description = "Trigger Lambda on SageMaker Model Package State Change"

  event_pattern = jsonencode({
    "source": ["aws.sagemaker"],
    "detail-type": ["SageMaker Model Package State Change"],
    "detail": {
      "ModelPackageStatus": ["Completed","Approved","PendingManualApproval"]
    }
  })
}

resource "aws_cloudwatch_event_target" "deploy_target" {
  rule = aws_cloudwatch_event_rule.sagemaker_model_package_change.name
  arn  = aws_lambda_function.deploy_model.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.deploy_model.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sagemaker_model_package_change.arn
}

