# Top-level
variable "app_network_access_type" {
  description = "APP network access type (e.g. VpcOnly or PublicInternetOnly)"
  type        = string
}

variable "app_security_group_management" {
  description = "App security group management mode, if any"
  type        = string
}

variable "auth_mode" {
  description = "Auth mode for the domain (IAM or AWS_IAM_IDENTITY_CENTER)"
  type        = string
}

variable "domain_name" {
  description = "SageMaker Studio Domain name"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (optional)"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the domain"
  type        = list(string)
}

variable "tag_propagation" {
  description = "Tag propagation mode"
  type        = string
}

variable "tags" {
  description = "Tags to attach to the domain"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID for the domain"
  type        = string
}

# ---------- default_space_settings ----------
variable "default_space_execution_role" {
  description = "Execution role ARN for default space"
  type        = string
}

variable "default_space_security_groups" {
  description = "Security groups for default space"
  type        = list(string)
}

variable "default_space_default_volume_size" {
  description = "Default EBS volume size (GB) for spaces"
  type        = number
}

variable "default_space_maximum_volume_size" {
  description = "Maximum EBS volume size (GB) for spaces"
  type        = number
}

# ---------- default_user_settings ----------
variable "default_user_auto_mount_home_efs" {
  description = "Auto-mount EFS for users (Enabled/Disabled/DefaultAsDomain or null)"
  type        = string
}

variable "default_user_default_landing_uri" {
  description = "Default landing URI (studio::, app:JupyterServer:, etc.)"
  type        = string
}

variable "default_user_execution_role" {
  description = "Execution role ARN for users"
  type        = string
}

variable "default_user_security_groups" {
  description = "Security groups attached to users"
  type        = list(string)
}

variable "default_user_studio_web_portal_status" {
  description = "Studio Web Portal status (ENABLED or DISABLED)"
  type        = string
}

variable "canvas_direct_deploy_status" {
  description = "Canvas direct deploy status (ENABLED or DISABLED)"
  type        = string
}

variable "generative_ai_bedrock_role_arn" {
  description = "IAM role ARN for Bedrock access from Canvas"
  type        = string
}

variable "generative_ai_status" {
  description = "Generative AI status for Canvas (ENABLED or DISABLED)"
  type        = string
}

variable "kendra_status" {
  description = "Kendra integration status for Canvas (ENABLED or DISABLED)"
  type        = string
}

variable "model_register_cross_account_role_arn" {
  description = "Role ARN for cross-account model registration (optional)"
  type        = string
}

variable "model_register_status" {
  description = "Model register status for Canvas (ENABLED or DISABLED)"
  type        = string
}

variable "forecast_role_arn" {
  description = "Forecast role ARN for Canvas time series"
  type        = string
}

variable "forecast_status" {
  description = "Forecast status for Canvas (ENABLED or DISABLED)"
  type        = string
}

variable "workspace_s3_artifact_path" {
  description = "S3 artifact path for Canvas workspace"
  type        = string
}

variable "workspace_s3_kms_key_id" {
  description = "KMS key ID for Canvas workspace artifacts"
  type        = string
}

variable "jupyter_lifecycle_config_arns" {
  description = "Lifecycle config ARNs for Jupyter servers"
  type        = list(string)
}

variable "jupyter_instance_type" {
  description = "Default Jupyter instance type (or 'system')"
  type        = string
}

variable "jupyter_lifecycle_config_arn" {
  description = "Default lifecycle config ARN for Jupyter"
  type        = string
}

variable "jupyter_image_arn" {
  description = "Default Jupyter image ARN"
  type        = string
}

variable "jupyter_image_version_alias" {
  description = "Default Jupyter image version alias"
  type        = string
}

variable "jupyter_image_version_arn" {
  description = "Default Jupyter image version ARN"
  type        = string
}

variable "sharing_notebook_output_option" {
  description = "Notebook sharing output option"
  type        = string
}

variable "sharing_s3_kms_key_id" {
  description = "KMS key for shared notebook S3 path"
  type        = string
}

variable "sharing_s3_output_path" {
  description = "S3 output path for shared notebooks"
  type        = string
}

variable "default_user_space_default_volume_size" {
  description = "Default user space EBS size in GB"
  type        = number
}

variable "default_user_space_maximum_volume_size" {
  description = "Max user space EBS size in GB"
  type        = number
}

variable "domain_execution_role_identity_config" {
  description = "Execution role identity config (optional)"
  type        = string
}

variable "domain_security_group_ids" {
  description = "Security group IDs for the domain"
  type        = list(string)
}