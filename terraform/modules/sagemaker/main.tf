# Model Package Group - create if not provided
resource "aws_sagemaker_model_package_group" "pkg_group" {
  count = var.model_package_group_name == "" ? 1 : 0
  model_package_group_name = "${var.env}-model-package-group"
  model_package_group_description = "Model registry for ${var.env}"
}

locals {
  model_pkg_group_name = var.model_package_group_name != "" ? var.model_package_group_name : aws_sagemaker_model_package_group.pkg_group[0].model_package_group_name
}

# SageMaker Domain (optional - created only if domain_name not provided)
resource "aws_sagemaker_domain" "studio" {
  count = var.domain_name == "" ? 1 : 0

  domain_name = "${var.env}-studio-domain"
  auth_mode   = "IAM"

  default_user_settings {
    execution_role = var.execution_role_arn
  }

  # pass null if not provided
  vpc_id     = var.vpc_id != "" ? var.vpc_id : null
  subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : null

  tags = { Name = "${var.env}-sagemaker-domain" }
}