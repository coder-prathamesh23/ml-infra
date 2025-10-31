data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  count = var.use_existing_vpc ? 0 : 1
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "${var.env}-vpc" }
}

resource "aws_subnet" "public" {
  count = var.use_existing_vpc ? 0 : length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.this[0].id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "${var.env}-public-${count.index}" }
}

resource "aws_subnet" "private" {
  count = var.use_existing_vpc ? 0 : length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this[0].id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = { Name = "${var.env}-private-${count.index}" }
}