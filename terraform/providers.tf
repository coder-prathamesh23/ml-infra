variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "assume_role_arn" {
  type    = string
  default = ""
}

variable "assume_role_session_name" {
  type    = string
  default = "tf-session"
}

provider "aws" {
  region = var.aws_region

  # Optional: allow Terraform Cloud to assume a role (set workspace var assume_role_arn if needed)
  assume_role {
    role_arn     = var.assume_role_arn
    session_name = var.assume_role_session_name
  }
}
