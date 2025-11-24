module "sagemaker" {
  source = "./modules/sagemaker"

  # Top-level
  app_network_access_type       = var.app_network_access_type
  app_security_group_management = var.app_security_group_management
  auth_mode                     = var.auth_mode
  domain_name                   = var.domain_name
  kms_key_id                    = var.kms_key_id
  subnet_ids                    = var.subnet_ids
  tag_propagation               = var.tag_propagation
  tags                          = var.tags
  vpc_id                        = var.vpc_id

  # default_space_settings
  default_space_execution_role       = var.default_space_execution_role
  default_space_security_groups      = var.default_space_security_groups
  default_space_default_volume_size  = var.default_space_default_volume_size
  default_space_maximum_volume_size  = var.default_space_maximum_volume_size

  # default_user_settings
  default_user_auto_mount_home_efs       = var.default_user_auto_mount_home_efs
  default_user_default_landing_uri       = var.default_user_default_landing_uri
  default_user_execution_role            = var.default_user_execution_role
  default_user_security_groups           = var.default_user_security_groups
  default_user_studio_web_portal_status  = var.default_user_studio_web_portal_status

  canvas_direct_deploy_status            = var.canvas_direct_deploy_status
  generative_ai_bedrock_role_arn         = var.generative_ai_bedrock_role_arn
  generative_ai_status                   = var.generative_ai_status
  kendra_status                          = var.kendra_status
  model_register_cross_account_role_arn  = var.model_register_cross_account_role_arn
  model_register_status                  = var.model_register_status
  forecast_role_arn                      = var.forecast_role_arn
  forecast_status                        = var.forecast_status

  workspace_s3_artifact_path             = var.workspace_s3_artifact_path
  workspace_s3_kms_key_id                = var.workspace_s3_kms_key_id

  jupyter_lifecycle_config_arns          = var.jupyter_lifecycle_config_arns
  jupyter_instance_type                  = var.jupyter_instance_type
  jupyter_lifecycle_config_arn           = var.jupyter_lifecycle_config_arn
  jupyter_image_arn                      = var.jupyter_image_arn
  jupyter_image_version_alias            = var.jupyter_image_version_alias
  jupyter_image_version_arn              = var.jupyter_image_version_arn

  sharing_notebook_output_option         = var.sharing_notebook_output_option
  sharing_s3_kms_key_id                  = var.sharing_s3_kms_key_id
  sharing_s3_output_path                 = var.sharing_s3_output_path

  default_user_space_default_volume_size = var.default_user_space_default_volume_size
  default_user_space_maximum_volume_size = var.default_user_space_maximum_volume_size

  domain_execution_role_identity_config  = var.domain_execution_role_identity_config
  domain_security_group_ids              = var.domain_security_group_ids
}