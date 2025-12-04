locals {
  # Works for:
  # "pse-mlops-artifacts-dev"
  # "s3://pse-mlops-artifacts-dev"
  # "s3://pse-mlops-artifacts-dev/some/prefix/"
  workspace_artifact_bucket_name = element(
    split("/", replace(var.workspace_s3_artifact_path, "s3://", "")),
    0
  )
}

################################
# Artifact bucket (optional)
################################

resource "aws_s3_bucket" "workspace_artifact" {
  count         = var.create_workspace_artifact_bucket ? 1 : 0
  bucket        = local.workspace_artifact_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "workspace_artifact_ownership" {
  count  = var.create_workspace_artifact_bucket ? 1 : 0
  bucket = aws_s3_bucket.workspace_artifact[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "workspace_artifact_private_acl" {
  count = var.create_workspace_artifact_bucket ? 1 : 0

  depends_on = [
    aws_s3_bucket_ownership_controls.workspace_artifact_ownership,
  ]

  bucket = aws_s3_bucket.workspace_artifact[0].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "workspace_artifact_versioning" {
  count  = var.create_workspace_artifact_bucket ? 1 : 0
  bucket = aws_s3_bucket.workspace_artifact[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "workspace_artifact_encryption" {
  count  = var.create_workspace_artifact_bucket ? 1 : 0
  bucket = aws_s3_bucket.workspace_artifact[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "workspace_artifact_public_access" {
  count  = var.create_workspace_artifact_bucket ? 1 : 0
  bucket = aws_s3_bucket.workspace_artifact[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
