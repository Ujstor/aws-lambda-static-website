locals {
  domain_segments = split(".", var.domain)
  domain_prefix   = length(local.domain_segments) > 2 ? join(".", slice(local.domain_segments, 0, length(local.domain_segments) - 2)) : "@"
}

module "acm" {
  source = "../../ACM-cert-manager/"

  domain      = var.domain
  environment = var.environment
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = module.acm.certificate_arn
  validation_record_fqdns = [for dvo in module.acm.CNAME_records : dvo.name]
}

resource "aws_apigatewayv2_domain_name" "lambda_domain" {
  domain_name = var.domain

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "example" {

  api_id      = module.api_gateway.apigateway2_api_id
  domain_name = aws_apigatewayv2_domain_name.lambda_domain.id
  stage       = module.api_gateway.apigateway2_stage_id
}

module "lambda_web" {
  source = "../../lambda/"

  lambda_config = {
    work_dir          = var.go_bin_dir
    bin_name          = "bootstrap"
    archive_bin_name  = "function.zip"
    handler           = "main"
    runtime           = "provided.al2023"
    ephemeral_storage = "512"
    archive_type      = "zip"
  }

  function_name   = var.lambda_func_name
  lambda_iam_role = module.lambda_iam_role.lambda_iam_role__arn
}

module "api_gateway" {
  source = "../../api-gateway-lambda"

  lambda_integration_route_premission = {
    integration_type                  = "AWS_PROXY"
    integration_method                = "POST"
    connection_type                   = "INTERNET"
    route_key                         = "GET /{proxy+}"
    statement_id                      = "AllowExecutionFromAPIGateway"
    action                            = "lambda:InvokeFunction"
    principal                         = "apigateway.amazonaws.com"
    authorizer_type                   = "REQUEST"
    indentity_sources                 = ["$request.header.Authorization"]
    authorizer_name                   = "example-authorizer"
    authorizer_payload_format_version = "1.0"
  }

  lambda_func_name  = module.lambda_web.lambda_arn.lambda_name
  lambda_invoke_arn = module.lambda_web.lambda_arn.lambda_arn
  authorizer_uri    = module.lambda_web.lambda_arn.invoke_arn

  api_gw_conf = {
    name          = var.lambda_func_name
    protocol_type = "HTTP"
  }

}

module "lambda_iam_role" {
  source = "../../roles/lambda-role/"

  iam_lambda_role_name = var.lambda_func_name
}


module "lambda_cloudWatch_iam_role" {
  source = "../../roles/lambda-cloudWatch/"

  providers = {
    aws = aws.sandbox
  }

  lambda_iam_role_name = module.lambda_iam_role.lambda_iam_role_name

  iam_lambda_cloudwatch_name = var.lambda_func_name
  function_name              = var.lambda_func_name

  depends_on = [module.lambda_iam_role]
}

resource "cloudflare_record" "api_gw_domain" {
  zone_id = var.cloudflare_zone_id
  name    = module.acm.CNAME_records[0].name
  value   = module.acm.CNAME_records[0].value
  type    = "CNAME"
  ttl     = 3600
  proxied = false
}

resource "cloudflare_record" "api_gw_domain_attach" {
  zone_id = var.cloudflare_zone_id
  name    = local.domain_prefix
  value   = aws_apigatewayv2_domain_name.lambda_domain.domain_name_configuration[0].target_domain_name
  type    = "CNAME"
  ttl     = 3600
  proxied = false
}
