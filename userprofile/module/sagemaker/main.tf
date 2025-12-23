resource "aws_sagemaker_user_profile" "this" {
  for_each = var.user_profiles

  domain_id          = aws_sagemaker_domain.this.id
  user_profile_name  = each.key

  user_settings {
    execution_role = coalesce(
      try(each.value.execution_role, null),
      var.default_user_execution_role
    )

    security_groups = coalesce(
      try(each.value.security_groups, null),
      var.default_user_security_groups
    )

    auto_mount_home_efs = var.default_user_auto_mount_home_efs
    default_landing_uri = var.default_user_default_landing_uri
    studio_web_portal   = var.default_user_studio_web_portal_status

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

  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
}
