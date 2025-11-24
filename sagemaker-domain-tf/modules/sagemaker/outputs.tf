output "domain_id" {
  description = "ID of the SageMaker domain"
  value       = aws_sagemaker_domain.this.id
}

output "domain_arn" {
  description = "ARN of the SageMaker domain"
  value       = aws_sagemaker_domain.this.arn
}

output "url" {
  description = "URL for SageMaker Studio"
  value       = aws_sagemaker_domain.this.url
}
