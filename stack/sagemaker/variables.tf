variable "app_network_access_type" {
  type        = string
  description = "SageMaker Studio app network access type"
}

variable "app_security_group_management" {
  type        = string
  description = "App security group management (or null)"
}

variable "auth_mode" {
  type        = string
  description = "Authentication mode for the SageMaker domain"
}

variable "domain_name" {
  type        = string
  description = "SageMaker domain name"
}

variable "kms_key_id" {
  type        = string
  description = "KMS key for the domain (or null)"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets used by the domain"
}

variable "tag_propagation" {
  type        = string
  description = "Tag propagation setting"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the domain"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the domain"
}

# --- default_space_settings ---

variable "default_space_execution_role" {
  type        = string
  description = "Execution role for default space settings"
}

variable "default_space_security_groups" {
  type        = list(string)
  description = "Security groups for default space settings"
}

variable "default_space_default_volume_size" {
  type        = number
  description = "Default EBS volume size (GB) for spaces"
}

variable "default_space_maximum_volume_size" {
  type        = number
  description = "Maximum EBS volume size (GB) for spaces"
}

# --- default_user_settings (top level) ---

variable "default_user_auto_mount_home_efs" {
  type        = string
  description = "Whether to auto mount home EFS (or null)"
}

variable "default_user_default_landing_uri" {
  type        = string
  description = "Default landing URI for Studio"
}

variable "default_user_execution_role" {
  type        = string
  description = "Execution role for default user settings"
}

variable "default_user_security_groups" {
  type        = list(string)
  description = "Security groups for default user settings"
}

variable "default_user_studio_web_portal_status" {
  type        = string
  description = "Studio web portal status"
}

# canvas_app_settings
variable "canvas_direct_deploy_status" {
  type        = string
  description = "Canvas direct deploy status"
}

# generative_ai_settings
variable "generative_ai_bedrock_role_arn" {
  type        = string
  description = "Amazon Bedrock role ARN for Canvas"
}

variable "generative_ai_status" {
  type        = string
  description = "Generative AI settings status"
}

# kendra_settings
variable "kendra_status" {
  type        = string
  description = "Kendra integration status"
}

# model_register_settings
variable "model_register_cross_account_role_arn" {
  type        = string
  description = "Cross-account model register role ARN (or null)"
}

variable "model_register_status" {
  type        = string
  description = "Model registry settings status"
}

# time_series_forecasting_settings
variable "forecast_role_arn" {
  type        = string
  description = "Amazon Forecast role ARN for Canvas"
}

variable "forecast_status" {
  type        = string
  description = "Time series forecasting settings status"
}

# workspace_settings
variable "workspace_s3_artifact_path" {
  type        = string
  description = "Workspace S3 artifact path"
}

variable "workspace_s3_kms_key_id" {
  type        = string
  description = "Workspace S3 KMS key ID (or null)"
}

# jupyter_server_app_settings
variable "jupyter_lifecycle_config_arns" {
  type        = list(string)
  description = "Lifecycle config ARNs for Jupyter server app"
}

variable "jupyter_instance_type" {
  type        = string
  description = "Instance type for default Jupyter server resource spec"
}

variable "jupyter_lifecycle_config_arn" {
  type        = string
  description = "Lifecycle config ARN for default Jupyter resource spec (or null)"
}

variable "jupyter_image_arn" {
  type        = string
  description = "SageMaker image ARN for Jupyter server"
}

variable "jupyter_image_version_alias" {
  type        = string
  description = "Jupyter image version alias (or null)"
}

variable "jupyter_image_version_arn" {
  type        = string
  description = "Jupyter image version ARN (or null)"
}

# sharing_settings
variable "sharing_notebook_output_option" {
  type        = string
  description = "Notebook output option for sharing"
}

variable "sharing_s3_kms_key_id" {
  type        = string
  description = "S3 KMS key for sharing (or null)"
}

variable "sharing_s3_output_path" {
  type        = string
  description = "S3 output path for sharing"
}

# default_user space_storage_settings
variable "default_user_space_default_volume_size" {
  type        = number
  description = "Default EBS volume size (GB) for user spaces"
}

variable "default_user_space_maximum_volume_size" {
  type        = number
  description = "Maximum EBS volume size (GB) for user spaces"
}

# --- domain_settings ---

variable "domain_execution_role_identity_config" {
  type        = string
  description = "Execution role identity config (or null)"
}

variable "domain_security_group_ids" {
  type        = list(string)
  description = "Security groups for domain settings"
}