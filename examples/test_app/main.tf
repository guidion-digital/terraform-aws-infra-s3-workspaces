variable "privileged_principal_arns" {}
variable "privileged_principal_actions" {}
variable "project" {}
variable "stage" {}
variable "applications" { default = {} }

module "workspaces" {
  source = "../../"

  project                      = var.project
  stage                        = var.stage
  privileged_principal_arns    = var.privileged_principal_arns
  privileged_principal_actions = var.privileged_principal_actions
  applications                 = var.applications
}
