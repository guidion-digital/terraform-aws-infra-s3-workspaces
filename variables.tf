variable "privileged_principal_arns" {
  description = "Special ARNs (such as roles), given var.privileged_principal_actions"
  type        = list(map(list(string)))
}

variable "privileged_principal_actions" {
  description = "Actions to allow to var.privileged_principal_arns"
  type        = list(string)

  default = ["s3:*"]
}

variable "project" {
  description = "Who is this for? A.K.A. 'team'"
}

variable "stage" {
  description = "A.K.A. 'environment'"
}

variable "applications" {
  description = <<-EOD
  Applications to create pretend S3 workspaces for

  applications = {
    service_types              = AWS services which may use the application role
    application_policy         = Added to the application role
    application_policy_arns    = Added to the application role
    terraform_variables        = Map of (Terraform) string variables to give the workspace
    terraform_hcl_variables    = Map of (Terraform) strings containing HCL variable
  }
  EOD

  type = map(object({
    service_types           = list(string),
    application_policy      = optional(string, ""),
    application_policy_arns = optional(list(string), []),
    terraform_variables     = optional(map(string), {}),
    terraform_hcl_variables = optional(map(any), {})
  }))

  default = {}
}

