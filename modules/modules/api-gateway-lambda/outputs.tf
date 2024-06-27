output "api_gateway_url" {
  description = "Lambda ARN-s and name"
  value       = aws_apigatewayv2_api.lambda_api.api_endpoint
}

output "apigateway2_api_id" {
  description = "API ID for api domain maping"
  value       = aws_apigatewayv2_api.lambda_api.id
}

output "apigateway2_stage_id" {
  description = "Stage ID for api domain maping"
  value       = aws_apigatewayv2_stage.lambda.id
}
