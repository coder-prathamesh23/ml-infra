terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.3"
    }
  }

  required_version = ">= 1.5.0, <= 1.13.4"
}

