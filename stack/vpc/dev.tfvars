env = "dev"

cidr_block = "10.10.0.0/16"

public_subnets = {
  0 = {
    availability_zone = "us-east-1a"
    cidr_block        = "10.10.0.0/20"
  },
  1 = {
    availability_zone = "us-east-1b"
    cidr_block        = "10.10.16.0/20"
  },
  2 = {
    availability_zone = "us-east-1c"
    cidr_block        = "10.10.32.0/20"
  },
  3 = {
    availability_zone = "us-east-1d"
    cidr_block        = "10.10.48.0/20"
  },
  4 = {
    availability_zone = "us-east-1e"
    cidr_block        = "10.10.64.0/20"
  },
  5 = {
    availability_zone = "us-east-1f"
    cidr_block        = "10.10.80.0/20"
  }
}

private_subnets = {
  0 = {
    availability_zone = "us-east-1a"
    cidr_block        = "10.10.96.0/20"
  },
  1 = {
    availability_zone = "us-east-1b"
    cidr_block        = "10.10.112.0/20"
  },
  2 = {
    availability_zone = "us-east-1c"
    cidr_block        = "10.10.128.0/20"
  },
  3 = {
    availability_zone = "us-east-1d"
    cidr_block        = "10.10.144.0/20"
  },
  4 = {
    availability_zone = "us-east-1e"
    cidr_block        = "10.10.160.0/20"
  },
  5 = {
    availability_zone = "us-east-1f"
    cidr_block        = "10.10.176.0/20"
  }
}

base_tags = {
  Name     = "dev-temp-plan"
  Deployed = "terraform"
}
