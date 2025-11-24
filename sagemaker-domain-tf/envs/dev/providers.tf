provider "aws" {
  region = "us-west-2"

  assume_role {
    role_arn     = ""
    session_name = ""
    external_id  = ""
  }
}