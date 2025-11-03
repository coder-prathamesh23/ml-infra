variable "env" {
  type    = string
  default = "dev"
}

variable "account_id" {
  type    = string
  default = ""
}

#VPC
variable "vpc_name" {
  type        = string
  description = "Friendly name for this VPC"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnets" {
  type = map(any) # assumes an object as defined below
  #default = {
  #  availability_zone = string
  #  cidr_block        = string
  #}
  description = "Public Subnets"
}

variable "private_subnets" {
  type = map(any)
  # assumes an object as defined below
  #default = {
  #  availability_zone = string
  #  cidr_block        = string
  #}
  description = "Private Subnets"
}

variable "artifact_bucket_name" {
  description = "Name for the S3 bucket used by SageMaker"
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "Map of tags to be passed to the VPC and VPC resources"
}


# SageMaker / Model Registry and domain names (optional pre-provided)
variable "model_package_group_name" {
  type    = string
  default = ""
}
variable "sagemaker_domain_name" {
  type    = string
  default = ""
}

variable "sagemaker_execution_role_arn" {
  description = "The ARN of the IAM role that SageMaker will assume to create the Model and Endpoint."
  type        = string
}

variable "accuracy_threshold" {
  description = "The minimum accuracy required for auto-approval."
  type        = string
  default     = "0.80"
}

variable "default_endpoint_name" {
  description = "The name of the SageMaker endpoint to create/update."
  type        = string
  default     = "ml-endpoint"
}

variable "inference_instance_type" {
  description = "The instance type for the SageMaker endpoint."
  type        = string
  default     = "ml.m5.large"
}

variable "pipeline_display_name" {
  description = "Display name of the SageMaker inference pipeline"
  type        = string
}

variable "security_group_ids" {
  description = "Security groups for SageMaker domain"
  type        = list(string)
}

variable "pipeline_name" {
  description = "Name of SageMaker inference pipeline"
  type        = string
}

variable "mvp_model_package_group_name" {
  description = "Name of utility model package group"
  type        = string
}

variable "pipeline_description" {
  description = "Description for SageMaker inference pipeline"
  type        = string
}