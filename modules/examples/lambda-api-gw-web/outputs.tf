output "lambda_web" {
  description = "Lambda ARN-s and name"
  value       = module.lambda_web.lambda_arn
}

output "api_gateway_url" {
  description = "Lambda ARN-s and name"
  value       = module.api_gateway.api_gateway_url
}
