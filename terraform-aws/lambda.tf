module "lambda" {
  source = "github.com/SthoreH/shd-terraform-aws-lambda?ref=v1.0.0"

  name          = local.function_name
  description   = local.function_description
  handler       = local.handler
  runtime       = local.runtime
  architectures = local.architectures
  layers        = local.layers
  role          = module.lambda_role.role_arn
  zip_file_path = local.lambda_zip_path

  environment_variables = merge(try(local.environment_variables, {}), var.environment_variables)

  publish_function = true
  alias            = local.function_alias

  log_retention_days = 14

  tags = local.tags
}
