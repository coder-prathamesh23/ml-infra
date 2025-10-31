variable "env" { 
    type = string 
}
variable "vpc_cidr" { 
    type = string 
}
variable "public_subnet_cidrs" { 
    type = list(string) 
}
variable "private_subnet_cidrs" { 
    type = list(string) 
}
variable "use_existing_vpc" { 
    type = bool 
}
variable "existing_vpc_id" { 
    type = string 
}
variable "existing_subnet_ids" { 
    type = list(string) 
}
