variable "domain_name" {
  description = "Name of the SageMaker domain"
  type        = string
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "security_group_ids" {
  description = "Security groups for SageMaker domain"
  type        = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "execution_role_arn" {
  description = "IAM role ARN for SageMaker"
  type        = string
}

variable "mvp_model_package_group_name" {
  description = "Name of utility model package group"
  type        = string
}

variable "pipeline_name" {
  description = "Name of SageMaker inference pipeline"
  type        = string
}

variable "pipeline_description" {
  description = "Description for SageMaker inference pipeline"
  type        = string
}

variable "pipeline_params" {
  description = "Map passed into the templatefile for pipeline parameters"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "Tags for SageMaker resources"
  type        = map(string)
  default     = {}
}

variable "pipeline_display_name" {
  description = "Display name of the SageMaker inference pipeline"
  type        = string
}
