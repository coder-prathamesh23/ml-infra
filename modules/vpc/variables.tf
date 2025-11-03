variable "vpc_name" {
  type        = string
  description = "Friendly name for this VPC"
}

variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment environment"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "map_pub_ip" {
  type    = bool
  default = true
}

variable "public_subnets" {
  type = map(any) # assumes an object as defined below
  #default = {
  #  availability_zone = string
  #  cidr_block        = string
  #}
  description = "Public Subnets"
}

variable "private_subnets" {
  type = map(any)
  # assumes an object as defined below
  #default = {
  #  availability_zone = string
  #  cidr_block        = string
  #}
  description = "Private Subnets"
}

variable "tags" {
  type        = map(any)
  description = "Map of tags to be passed to the VPC and VPC resources"
}
