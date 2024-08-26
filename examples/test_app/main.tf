module "workspaces" {
  source = "../../"

  project                      = "test"
  stage                        = "dev"
  privileged_principal_arns    = [{ "arn:aws:iam::000000000000:role/Test" = [""] }]
  privileged_principal_actions = ["s3:*"]
  applications = {}
}
