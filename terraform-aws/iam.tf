module "lambda_role" {
  source = "github.com/SthoreH/shd-terraform-aws-iam?ref=v1.1.2"

  role_name                   = "${local.function_name}-role"
  assume_role_policy_document = templatefile("${path.module}/iam_templates/trust/lambda_assume_role.tftpl", local.template_variables)

  policies = [
    {
      name        = "${local.function_name}-application-policy"
      description = "Application permissions for Lambda execution"
      document    = templatefile("${path.module}/iam_templates/policies/application_policy.tftpl", local.template_variables)
    },
    {
      name        = "${local.function_name}-default-policy"
      description = "Default minimum permissions for Lambda execution"
      document    = templatefile("${path.module}/iam_templates/policies/default_policy.tftpl", local.template_variables)
    }
  ]

  tags = local.tags
}
