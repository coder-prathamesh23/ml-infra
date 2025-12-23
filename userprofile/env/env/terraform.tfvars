user_profiles = {
  "ds-pse-dev-user1" = {
    # optional overrides (otherwise it inherits default_user_execution_role + default_user_security_groups)
    execution_role  = "arn:aws:iam::324644393892:role/SageMaker-ExecutionRole-Privileged"
    security_groups = ["sg-0b1d6dc461c2945d7"]
    tags = {
      owner = "dev-user1"
    }
  }

  "ds-pse-dev-user2" = {
    # inherit defaults
  }
}
