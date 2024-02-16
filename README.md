Part of the [Terrappy framework](https://github.com/guidion-digital/terrappy).

---

Helper module to create resources necessary for mimicking a Terraform Cloud Workspace (using an S3 bucket and a DynamoDB table).

# Rationale

When using Terraform Cloud for workspace management isn't feasible or desired, you can still get most of the benefits of the Terrappy framework by using a pretend TFC workspace with this module:

* S3 + DynamoDB for state storage and locking
* S3 object; `terraform.tfvars` written to mimic variable provisioning inside workspaces

Providing this subset of features means that we can keep this module mostly API compatible with the real [TFE Workspaces](https://github.com/guidion-digital/terraform-tfe-infra-workspaces/) module.

The main use-case is for development environments, where permissions and states are more loose and fast. Runs using this "workspace" will not eat into your TFC runs quota, which is a nice side-effect.

# Usage

See [examples folder](./examples).

# Caveats and Good-to-Knows

Since this module is designed to be used as an alternative to TFC workspaces created by the [TFE Workspaces module](https://github.com/guidion-digital/terraform-tfe-infra-workspaces/), there is no `var.applications{}.workspace_policy`, as there is in that module. This means that the workspace permissions [detailed in Terrappy](https://github.com/guidion-digital/terrappy/blob/master/permissions.md#L1) do not apply (because we do not create an IAM user and token for the "workspace" with this module). Instead, you must ensure the role being used to create resources inside the resulting workspace (e.g. the one assigned to your user, if you're running this directly from the CLI) has the necessary permissions to create IAM roles and policies, as well as the `iam:pass_role` permission for those roles.

The `application_policy_arns` list can only contain pre-existing policies. If you need to create policies for the application to use, attach them to a role, and pass the full list of all roles to be allowed for attachment to the application services to `application_role_arn_names`. Alternatively, you can create the policies in one commit, and add them to the `application_policy_arns` field in another, though this isn't recommended.

---

# Attributions:

Uses the [CloudPosse S3 Bucket module](https://github.com/cloudposse/terraform-aws-s3-bucket) for bucket creation.
