############################################
# Outputs for SageMaker module
############################################

output "domain_arn" {
  description = "ARN of the created SageMaker domain"
  value       = aws_sagemaker_domain.datalake_domain.arn
}

output "mvp_model_package_group_arn" {
  description = "ARN of the utility model package group"
  value       = aws_sagemaker_model_package_group.utility_model_package_group.arn
}
