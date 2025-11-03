# terraform {
#   cloud {
#     hostname     = "app.terraform.io"     # change if you use a private TFC hostname
#     organization = "<TFC_ORGANIZATION>"   # REPLACE
#     workspaces {
#       name = "<TFC_WORKSPACE>"             # REPLACE: use per-environment workspaces e.g. dev, stage, prod
#     }
#   }

#   required_version = ">= 1.5.0, <= 1.13.4"
# }
terraform {
  required_version = ">= 1.5.0, <= 1.13.4"

  # Use local backend so no Terraform Cloud login is needed
  backend "local" {
    path = "terraform.tfstate"
  }
}
