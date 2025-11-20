output "sagemaker_domain_id" {
  description = "ID of the cloned SageMaker Studio domain"
  value       = module.sagemaker_domain.domain_id
}

output "sagemaker_domain_arn" {
  description = "ARN of the cloned SageMaker Studio domain"
  value       = module.sagemaker_domain.domain_arn
}
