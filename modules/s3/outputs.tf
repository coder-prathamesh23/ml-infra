################################
# Outputs for S3 module
################################

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.mlops_artifacts.bucket
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.mlops_artifacts.arn
}

output "bucket_acl" {
  description = "ACL applied to the bucket"
  value       = aws_s3_bucket_acl.private_acl.acl
}

output "bucket_ownership" {
  description = "Ownership control setting"
  value       = aws_s3_bucket_ownership_controls.ownership.rule[0].object_ownership
}
