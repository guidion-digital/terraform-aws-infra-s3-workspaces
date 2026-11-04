module "workspaces_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "3.1.1"

  name                         = "${var.project}-${var.stage}-terraform-backends"
  acl                          = "private"
  enabled                      = true
  versioning_enabled           = true
  privileged_principal_arns    = var.privileged_principal_arns
  privileged_principal_actions = var.privileged_principal_actions

  lifecycle_configuration_rules = [{
    enabled                                = true
    id                                     = "max-versions"
    abort_incomplete_multipart_upload_days = null
    filter_and                             = null
    expiration                             = null
    transition                             = []
    noncurrent_version_transition          = []

    # Keep the current version plus (max_versions - 1) noncurrent versions.
    # S3 requires noncurrent_days >= 1, so excess versions are removed one day
    # after becoming noncurrent.
    noncurrent_version_expiration = {
      newer_noncurrent_versions = var.max_versions > 1 ? var.max_versions - 1 : null
      noncurrent_days           = 1
    }
  }]
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
  project                 = var.project
  stage                   = var.stage
  bucket                  = module.workspaces_bucket.bucket_id
  terraform_variables     = each.value.terraform_variables
  terraform_hcl_variables = each.value.terraform_hcl_variables
  application_policy      = each.value.application_policy
  application_policy_arns = each.value.application_policy_arns
  service_types           = each.value.service_types
}
