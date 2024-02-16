The example includes a value for `var.privileged_principal_actions`, which is actually the default value.

An explanation of `var.privileged_principal_arns` from [the submodule used](https://registry.terraform.io/modules/cloudposse/s3-bucket/aws/3.1.1?tab=inputs):

> Description: List of maps. Each map has a key, an IAM Principal ARN, whose associated value is a list of S3 path prefixes to grant `privileged_principal_actions` permissions for that principal, in addition to the bucket itself, which is automatically included. Prefixes should not begin with '/'.
