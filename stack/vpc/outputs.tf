output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "CIDR Range for VPC"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnets
  description = "List of private subnets IDs from VPC module"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnets
  description = "List of public subnet IDs from VPC module"
}

output "public_route_table_id" {
  value       = module.vpc.public_route_table_id
  description = "Returns public route table id"
}

output "private_route_table_ids" {
  value       = module.vpc.private_route_table_ids
  description = "List of private route table ids"
}

output "shared_db_security_group_id" {
  value       = aws_security_group.shared_db.id
  description = "Shared DB security group for this VPC"
}

output "public_nat_cidr_blocks" {
  value       = module.vpc.public_nat_cidr_blocks
  description = "Public NAT Gateway IP CIDR Ranges"
}
