#VPC

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  # instance_tenancy = default
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = var.tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags
}

resource "aws_eip" "nat_gateway" {
  for_each = var.public_subnets
  domain   = "vpc"
  tags     = var.tags

  depends_on = [
    aws_internet_gateway.this
  ]
}

resource "aws_nat_gateway" "this" {
  for_each      = var.public_subnets
  allocation_id = aws_eip.nat_gateway[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = var.tags
}

resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.this.id
  availability_zone       = var.public_subnets[each.key].availability_zone
  cidr_block              = var.public_subnets[each.key].cidr_block
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-${var.public_subnets[each.key].availability_zone}"
    Type = "public"
  })
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.this.id
  availability_zone = var.private_subnets[each.key].availability_zone
  cidr_block        = var.private_subnets[each.key].cidr_block

  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-${var.private_subnets[each.key].availability_zone}"
    Type = "private"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public"
    Type = "public"
  })
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-${aws_subnet.private[each.key].availability_zone}"
    Type = "private"
  })
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "nat" {
  for_each               = var.private_subnets
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = aws_subnet.private[each.key].id
}
