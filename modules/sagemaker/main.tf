#######################################
# SageMaker Domain
#######################################

resource "aws_sagemaker_domain" "datalake_domain" {
  domain_name = var.domain_name
  auth_mode   = "IAM"
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids

  app_network_access_type = "VpcOnly"

  domain_settings {
    security_group_ids = var.security_group_ids
  }

  default_space_settings {
    security_groups = var.security_group_ids
    execution_role  = var.execution_role_arn
  }

  default_user_settings {
    security_groups = var.security_group_ids
    execution_role  = var.execution_role_arn
  }
}

#######################################
# SageMaker Model Package security_groups
#######################################

resource "aws_sagemaker_model_package_group" "utility_model_package_group" {
  model_package_group_name        = var.mvp_model_package_group_name
  model_package_group_description = "Utility model package group for reusable models"
}

