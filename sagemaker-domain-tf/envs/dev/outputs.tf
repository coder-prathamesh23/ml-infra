output "sagemaker_id" {
  description = "ID of the SageMaker domain"
  value       = module.sagemaker.domain_id
}

output "sagemaker_arn" {
  description = "ARN of the SageMaker domain"
  value       = module.sagemaker.domain_arn
}

output "sagemaker_url" {
  description = "URL for SageMaker Studio"
  value       = module.sagemaker.url
}