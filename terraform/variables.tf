variable "env" {
  type    = string
  default = "dev"
}

variable "account_id" {
  type    = string
  default = ""
}

# VPC config
variable "use_existing_vpc" {
  type    = bool
  default = false
}
variable "existing_vpc_id" {
  type    = string
  default = ""
}
variable "existing_subnet_ids" {
  type    = list(string)
  default = []
}
variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.11.0/24", "10.10.12.0/24"]
}

# SageMaker / Model Registry and domain names (optional pre-provided)
variable "model_package_group_name" {
  type    = string
  default = ""
}
variable "sagemaker_domain_name" {
  type    = string
  default = ""
}
