output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR Range for VPC"
  value       = aws_vpc.this.cidr_block
}

output "subnets" {
  description = "Subnet objects"

  value = {
    public  = aws_subnet.public
    private = aws_subnet.private
  }
}

output "subnet_ids" {
  description = "Subnet IDs, public, private"
  value = {
    public  = [for subnet in aws_subnet.public : subnet.id]
    private = [for subnet in aws_subnet.private : subnet.id]
  }
}

output "public_subnets" {
  description = "Public Subnets of the VPC"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnets" {
  description = "Private Subnets of the VPC"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "public_route_table_id" {
  description = "Public subnet route table ID for the VPC"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "List of Private subnet route table IDs of VPC"
  value       = [for table in aws_route_table.private : table.id]
}

output "public_nat_cidr_blocks" {
  description = "Public NAT Gateway IP CIDR Ranges"
  value       = [for nat in aws_eip.nat_gateway : "${nat.public_ip}/32"]
}
