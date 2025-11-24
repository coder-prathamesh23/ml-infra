resource "aws_sagemaker_domain" "this" {
  app_network_access_type       = var.app_network_access_type
  app_security_group_management = var.app_security_group_management
  auth_mode                     = var.auth_mode
  domain_name                   = var.domain_name
  kms_key_id                    = var.kms_key_id
  subnet_ids                    = var.subnet_ids
  tag_propagation               = var.tag_propagation
  tags                          = var.tags
  vpc_id                        = var.vpc_id

  # ---------- default_space_settings ----------
  default_space_settings {
    execution_role  = var.default_space_execution_role
    security_groups = var.default_space_security_groups

    space_storage_settings {
      default_ebs_storage_settings {
        default_ebs_volume_size_in_gb = var.default_space_default_volume_size
        maximum_ebs_volume_size_in_gb = var.default_space_maximum_volume_size
      }
    }
  }

  # ---------- default_user_settings ----------
  default_user_settings {
    auto_mount_home_efs = var.default_user_auto_mount_home_efs
    default_landing_uri = var.default_user_default_landing_uri

    execution_role  = var.default_user_execution_role
    security_groups = var.default_user_security_groups

    # string field, not object
    studio_web_portal = var.default_user_studio_web_portal_status

    # Canvas app settings and all its sub-blocks
    canvas_app_settings {
      direct_deploy_settings {
        status = var.canvas_direct_deploy_status
      }

      generative_ai_settings {
        amazon_bedrock_role_arn = var.generative_ai_bedrock_role_arn
        status                  = var.generative_ai_status
      }

      kendra_settings {
        status = var.kendra_status
      }

      model_register_settings {
        cross_account_model_register_role_arn = var.model_register_cross_account_role_arn
        status                                = var.model_register_status
      }

      time_series_forecasting_settings {
        amazon_forecast_role_arn = var.forecast_role_arn
        status                   = var.forecast_status
      }

      workspace_settings {
        s3_artifact_path = var.workspace_s3_artifact_path
        s3_kms_key_id    = var.workspace_s3_kms_key_id
      }
    }

    jupyter_server_app_settings {
      lifecycle_config_arns = var.jupyter_lifecycle_config_arns

      default_resource_spec {
        instance_type                 = var.jupyter_instance_type
        lifecycle_config_arn          = var.jupyter_lifecycle_config_arn
        sagemaker_image_arn           = var.jupyter_image_arn
        sagemaker_image_version_alias = var.jupyter_image_version_alias
        sagemaker_image_version_arn   = var.jupyter_image_version_arn
      }
    }

    sharing_settings {
      notebook_output_option = var.sharing_notebook_output_option
      s3_kms_key_id          = var.sharing_s3_kms_key_id
      s3_output_path         = var.sharing_s3_output_path
    }

    space_storage_settings {
      default_ebs_storage_settings {
        default_ebs_volume_size_in_gb = var.default_user_space_default_volume_size
        maximum_ebs_volume_size_in_gb = var.default_user_space_maximum_volume_size
      }
    }
  }

  # ---------- domain_settings ----------
  domain_settings {
    execution_role_identity_config = var.domain_execution_role_identity_config
    security_group_ids             = var.domain_security_group_ids
  }
}