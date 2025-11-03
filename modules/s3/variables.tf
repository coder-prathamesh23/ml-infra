variable "artifact_bucket_name" {
  description = "Name for the S3 bucket used by SageMaker"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
