output "lambda_web" {
  description = "Lambda ARN-s and name"
  value       = module.lambda_web.lambda_arn
}

output "invoke_url" {
  description = "Invoke URL"
  value       = module.lambda_web.invoke_url
}

