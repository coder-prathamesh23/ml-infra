output "vpc_id" {
  value = var.use_existing_vpc ? var.existing_vpc_id : aws_vpc.this[0].id
}

output "private_subnet_ids" {
  value = var.use_existing_vpc ? var.existing_subnet_ids : aws_subnet.private[*].id
}
