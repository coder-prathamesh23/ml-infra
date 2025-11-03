################################
# S3 Bucket for SageMaker artifacts
################################

resource "aws_s3_bucket" "mlops_artifacts" {
  bucket        = var.artifact_bucket_name
  force_destroy = true
}

################################
# Ownership Control - Bucket Owner preferred
################################

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.mlops_artifacts.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

################################
# Private assume_role_policy
################################

resource "aws_s3_bucket_acl" "private_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership]
  bucket     = aws_s3_bucket.mlops_artifacts.id
  acl        = "private"
}

################################
# Enable Versioning
################################

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.mlops_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

################################
# Server-Side Encryption (SSE-S3)
################################

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.mlops_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

################################
# Public Access Block - Security best practice
################################

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.mlops_artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

################################
# SageMaker Access Policy
################################

resource "aws_s3_bucket_policy" "sagemaker_policy" {
  bucket = aws_s3_bucket.mlops_artifacts.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSageMakerAccess"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ]
        Resource = [
          aws_s3_bucket.mlops_artifacts.arn,
          "${aws_s3_bucket.mlops_artifacts.arn}/*"
        ]
      }
    ]
  })
}
