output "lambda_arn" {
  description = "Lambda ARN-s and name"
  value       = module.lambda.lambda_arn
}

output "invoke_url" {
  description = "Invoke URL"
  value       = module.lambda.invoke_url
}

