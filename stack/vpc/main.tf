module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = var.vpc_name
  env             = var.env
  cidr_block      = var.cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

