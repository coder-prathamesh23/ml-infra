output "bucket" { 
    value = aws_s3_bucket.ml_artifacts.bucket 
}
output "bucket_arn" { 
    value = aws_s3_bucket.ml_artifacts.arn 
}
output "kms_key_arn" { 
    value = aws_kms_key.sagemaker.arn 
}
