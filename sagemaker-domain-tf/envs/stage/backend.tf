terraform {
  required_version = ">= 1.1.0"

  cloud {
    hostname     = "tf.puget.com"
    organization = "DataScience"

    workspaces {
      name = ""
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}