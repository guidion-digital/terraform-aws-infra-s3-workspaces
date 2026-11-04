This example is written to run against [MiniStack](https://github.com/ministackorg/ministack), which emulates AWS locally. CI (the terrappy reusable workflows) starts MiniStack as a service and runs `terraform plan` on pull requests and `terraform apply` on pushes to `acc`.

## Requirements

The example has no provider configuration of its own. It relies on these environment variables, which CI/CD always sets and which you must set yourself when running the example locally:

```sh
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_REGION=eu-central-1
```

Without `AWS_ENDPOINT_URL`, the example would run against whichever real AWS account your credentials point to.

## Running locally

```sh
docker run -d --name ministack -p 4566:4566 ministackorg/ministack:1.5.31
terraform init
terraform apply
docker rm -f ministack # MiniStack keeps everything in the container, so this clears it
```

## Notes

The example includes a value for `var.privileged_principal_actions`, which is actually the default value.

An explanation of `var.privileged_principal_arns` from [the submodule used](https://registry.terraform.io/modules/cloudposse/s3-bucket/aws/3.1.1?tab=inputs):

> Description: List of maps. Each map has a key, an IAM Principal ARN, whose associated value is a list of S3 path prefixes to grant `privileged_principal_actions` permissions for that principal, in addition to the bucket itself, which is automatically included. Prefixes should not begin with '/'.
