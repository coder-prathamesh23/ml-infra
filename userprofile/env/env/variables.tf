variable "user_profiles" {
  description = "User profiles to create for this environment/domain"
  type = map(object({
    execution_role  = optional(string)
    security_groups = optional(list(string))
    tags            = optional(map(string))
  }))
  default = {}
}
