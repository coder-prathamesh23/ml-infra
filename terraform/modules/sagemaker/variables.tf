variable "env" { 
    type = string 
}
variable "execution_role_arn" { 
    type = string 
}
variable "vpc_id" { 
    type = string 
}
variable "subnet_ids" { 
    type = list(string)
    default = [] 
}
variable "domain_name" { 
    type = string
    default = "" 
}
variable "model_package_group_name" { 
    type = string
    default = "" 
}