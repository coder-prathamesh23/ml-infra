resource "aws_kms_key" "sagemaker" {
  description = "KMS key for ml artifacts - ${var.env}"
  enable_key_rotation = true
  tags = { Name = "${var.env}-sagemaker-kms" }
}

resource "random_id" "suf" { byte_length = 4 }

resource "aws_s3_bucket" "ml_artifacts" {
  bucket = "mlops-${var.env}-${random_id.suf.hex}"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.sagemaker.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning { enabled = true }

  tags = { Name = "${var.env}-ml-artifacts" }
}
