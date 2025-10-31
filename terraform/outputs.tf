output "s3_bucket" {
  value = module.s3.bucket
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "kms_key_arn" {
  value = module.s3.kms_key_arn
}

output "sagemaker_domain_id" {
  value = module.sagemaker.domain_id
}

output "model_package_group_name" {
  value = module.sagemaker.model_package_group_name
}

output "sagemaker_execution_role_arn" {
  value = module.iam.sagemaker_execution_role_arn
}

output "lambda_arn" {
  value = aws_lambda_function.deploy_model.arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

