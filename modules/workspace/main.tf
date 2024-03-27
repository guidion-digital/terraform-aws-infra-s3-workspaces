locals {
  services = [for this_service in var.service_types : "${this_service}.amazonaws.com"]
}

resource "aws_iam_role" "application" {
  name = "${var.project}-${var.stage}-${var.name}"
  path = "/application/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = { Service = local.services }
      },
    ]
  })

  tags = {
    source = "s3_workspace"
  }
}

# Create and attach any application policy definitions we're given
resource "aws_iam_policy" "application" {
  count = length(var.application_policy) != 0 ? 1 : 0

  name   = "aux-${var.name}"
  path   = "/application/"
  policy = var.application_policy
}
resource "aws_iam_role_policy_attachment" "application" {
  count = length(var.application_policy) != 0 ? 1 : 0

  role       = aws_iam_role.application.name
  policy_arn = aws_iam_policy.application[0].arn
}

# Attach any ready-made ARNs we're passed to the role we create
resource "aws_iam_role_policy_attachment" "application_policy_arns" {
  for_each = toset(var.application_policy_arns)

  role       = aws_iam_role.application.name
  policy_arn = each.value
}

locals {
  terraform_variables = merge(var.terraform_variables, { role_arn = aws_iam_role.application.arn })
}

resource "aws_s3_object" "terraform_tfvars" {
  bucket = var.bucket
  key    = "${var.name}/terraform.tfvars"

  content = templatefile("${path.module}/terraform.tfvars.tftpl", {
    these_variables     = local.terraform_variables,
    these_hcl_variables = var.terraform_hcl_variables
  })

  content_type = "text/plain"
}
