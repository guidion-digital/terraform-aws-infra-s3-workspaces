# Global variables
variables {
  project                      = "constr"
  stage                        = "dev"
  privileged_principal_arns    = [{ "arn:aws:iam::123456789012:role/SuperRole" = [""] }]
  privileged_principal_actions = ["s3:*"]

  applications = {
    "api-app-x" = {
      application_policy      = ""
      application_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"],
      service_types           = ["cloudfront", "lambda", "edgelambda"],

      terraform_variables = {
        parent_zone      = "dev.constr.guidion.io",
        application_name = "api-app-x"
      }

      terraform_hcl_variables = {
        "foo" = "bar"
      }
    }
  }
}

# Application instance tests
#
run "application_workspaces" {
  module {
    source = "./examples/test_app"
  }

  command = plan

  variables {
    project                      = var.project
    stage                        = var.stage
    privileged_principal_arns    = var.privileged_principal_arns
    privileged_principal_actions = var.privileged_principal_actions
    applications                 = var.applications
  }

  assert {
    condition     = contains(keys(module.workspaces.workspaces), "api-app-x")
    error_message = "An application workspace that should have been created, wasn't"
  }
}
