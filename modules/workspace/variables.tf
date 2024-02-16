variable "name" {
  description = "Will be used for the S3 folder name, analegous to the 'workspace' name in TFC"
  type        = string
}

variable "terraform_variables" {
  description = "Variables to write to tfvars file"
  type        = map(string)
}

variable "terraform_hcl_variables" {
  description = "Variables to write to tfvars file"
  type        = map(string)
}

variable "application_policy_arns" {
  description = "Policy ARNs to add to the new application role"
  type        = list(string)
}

variable "application_policy" {
  description = "A policy to add to the application role"
  type        = string
}

variable "service_types" {
  description = "Needed in order to allow assumerole from these types"
  type        = list(string)

  validation {
    condition     = !contains([for this_type in var.service_types : contains(["lambda", "ec2", "ecs-tasks", "cloudfront", "edgelambda"], this_type)], false)
    error_message = "Valid service types are: lambda, ec2, ecs-tasks, cloudfront, edgelambda"
  }
}

variable "bucket" {
  description = "Name of bucket where 'workspace' will reside"
  type        = string
}
