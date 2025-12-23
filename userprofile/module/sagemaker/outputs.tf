output "user_profile_arns" {
  description = "ARNs of created SageMaker user profiles"
  value       = { for k, v in aws_sagemaker_user_profile.this : k => v.arn }
}

output "user_profile_names" {
  description = "Names of created SageMaker user profiles"
  value       = keys(aws_sagemaker_user_profile.this)
}
