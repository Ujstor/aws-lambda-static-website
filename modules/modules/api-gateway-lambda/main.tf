resource "aws_apigatewayv2_api" "lambda_api" {
  name          = var.api_gw_conf.name
  protocol_type = var.api_gw_conf.protocol_type

  cors_configuration {
    allow_headers = [
      "Content-Type",
      "Authorization",
      "Accept",
      "Origin",
      "X-Requested-With",
      "Access-Control-Allow-Origin"
    ]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda_api.id

  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/vendedlogs/api_gw/${aws_apigatewayv2_api.lambda_api.name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "lambda_integration" {

  api_id             = aws_apigatewayv2_api.lambda_api.id
  integration_type   = var.lambda_integration_route_premission.integration_type
  integration_uri    = var.lambda_invoke_arn
  integration_method = var.lambda_integration_route_premission.integration_method
  connection_type    = var.lambda_integration_route_premission.connection_type
}

resource "aws_apigatewayv2_route" "route" {

  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = var.lambda_integration_route_premission.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "apigateway_permission" {

  statement_id  = var.lambda_integration_route_premission.statement_id
  action        = var.lambda_integration_route_premission.action
  function_name = var.lambda_func_name
  principal     = var.lambda_integration_route_premission.principal

  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*/*"
}

resource "aws_apigatewayv2_authorizer" "lambda_authorizer" {

  api_id                            = aws_apigatewayv2_api.lambda_api.id
  authorizer_type                   = var.lambda_integration_route_premission.authorizer_type
  authorizer_uri                    = var.authorizer_uri
  identity_sources                  = var.lambda_integration_route_premission.indentity_sources
  name                              = var.lambda_integration_route_premission.authorizer_name
  authorizer_payload_format_version = var.lambda_integration_route_premission.authorizer_payload_format_version
}
