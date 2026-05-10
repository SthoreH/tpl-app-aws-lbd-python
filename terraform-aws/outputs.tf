output "lambda_arn" {
  description = "ARN of the deployed Lambda function"
  value       = module.lambda.lambda_arn
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = module.lambda.lambda_function_name
}

output "lambda_role_arn" {
  description = "IAM role ARN attached to the Lambda"
  value       = module.lambda_role.role_arn
}
