output "api_gateway_url" {
  description = "Lambda ARN-s and name"
  value       = aws_apigatewayv2_api.lambda_api.api_endpoint
}

