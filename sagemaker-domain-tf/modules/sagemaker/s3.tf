################################
# Artifact bucket (optional)
################################

resource "aws_s3_bucket" "mlops_artifact" {
  count         = var.create_artifact_bucket ? 1 : 0
  bucket        = var.artifact_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "artifact_ownership" {
  count = var.create_artifact_bucket ? 1 : 0
  bucket = aws_s3_bucket.mlops_artifact[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "artifact_private_acl" {
  count = var.create_artifact_bucket ? 1 : 0

  depends_on = [
    aws_s3_bucket_ownership_controls.artifact_ownership,
  ]

  bucket = aws_s3_bucket.mlops_artifact[0].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "artifact_versioning" {
  count  = var.create_artifact_bucket ? 1 : 0
  bucket = aws_s3_bucket.mlops_artifact[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_encryption" {
  count  = var.create_artifact_bucket ? 1 : 0
  bucket = aws_s3_bucket.mlops_artifact[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifact_public_access" {
  count  = var.create_artifact_bucket ? 1 : 0
  bucket = aws_s3_bucket.mlops_artifact[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
