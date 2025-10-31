output "model_package_group_name" {
  value = local.model_pkg_group_name
}

output "domain_id" {
  value = var.domain_name != "" ? var.domain_name : aws_sagemaker_domain.studio[0].id
}
