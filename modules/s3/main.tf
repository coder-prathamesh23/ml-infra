################################
# S3 Buckets for SageMaker artifacts (multiple)
################################

resource "aws_s3_bucket" "mlops_artifacts" {
  # One instance per bucket name
  for_each = toset(var.artifact_bucket_names)

  bucket        = each.value
  force_destroy = true
}

################################
# Ownership Control - Bucket Owner preferred
################################

resource "aws_s3_bucket_ownership_controls" "ownership" {
  # Match one-to-one with buckets
  for_each = aws_s3_bucket.mlops_artifacts

  bucket = each.value.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

################################
# Private ACL
################################

resource "aws_s3_bucket_acl" "private_acl" {
  for_each = aws_s3_bucket.mlops_artifacts

  # Ensure ownership controls are applied first for this bucket
  depends_on = [aws_s3_bucket_ownership_controls.ownership[each.key]]

  bucket = each.value.id
  acl    = "private"
}

################################
# Enable Versioning
################################

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = aws_s3_bucket.mlops_artifacts

  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

################################
# Server-Side Encryption (SSE-S3)
################################

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  for_each = aws_s3_bucket.mlops_artifacts

  bucket = each.value.id

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
  for_each = aws_s3_bucket_mlops_artifacts

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
