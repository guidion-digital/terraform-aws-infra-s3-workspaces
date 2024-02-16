module "workspaces_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "3.1.1"

  name                         = "${var.project}-${var.stage}-terraform-backends"
  acl                          = "private"
  enabled                      = true
  versioning_enabled           = true
  privileged_principal_arns    = var.privileged_principal_arns
  privileged_principal_actions = var.privileged_principal_actions
}

resource "aws_dynamodb_table" "statefile_locks" {
  hash_key     = "LockID"
  name         = "${var.project}-${var.stage}-terraform-backends-statefile-locks"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

module "workspace" {
  source = "./modules/workspace"

  for_each = var.applications

  name                    = each.key
  bucket                  = module.workspaces_bucket.bucket_id
  terraform_variables     = each.value.terraform_variables
  terraform_hcl_variables = each.value.terraform_hcl_variables
  application_policy      = each.value.application_policy
  application_policy_arns = each.value.application_policy_arns
  service_types           = each.value.service_types
}
