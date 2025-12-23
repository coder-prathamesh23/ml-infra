variable "user_profiles" {
  description = "Map of SageMaker user profiles to create in this domain. Key = user_profile_name."
  type = map(object({
    execution_role  = optional(string)
    security_groups = optional(list(string))
    tags            = optional(map(string))
  }))
  default = {}
}

