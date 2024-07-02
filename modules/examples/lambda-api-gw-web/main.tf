module "lambda_web" {
  source = "../../modules/lambda/"

  providers = {
    aws = aws.sandbox
  }

  lambda_config = {
    work_dir          = "../go-lambda-code/web-test/"
    bin_name          = "bootstrap"
    archive_bin_name  = "function.zip"
    handler           = "main"
    runtime           = "provided.al2023"
    ephemeral_storage = "512"
    archive_type      = "zip"
  }

  function_name   = var.environment
  lambda_iam_role = module.lambda_iam_role.lambda_iam_role_arn

}

module "api_gateway" {
  source = "../../modules/api-gateway-lambda"

  providers = {
    aws = aws.sandbox
  }

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
    name          = var.environment
    protocol_type = "HTTP"
  }

}

module "lambda_iam_role" {
  source = "../../modules/roles/lambda-role/"

  providers = {
    aws = aws.sandbox
  }

  iam_lambda_role_name = var.environment
}

module "lambda_cloudWatch_iam_role" {
  source = "../../modules/roles/lambda-cloudWatch/"

  providers = {
    aws = aws.sandbox
  }

  lambda_iam_role_name = module.lambda_iam_role.lambda_iam_role_name

  iam_lambda_cloudwatch_name = var.environment
  function_name              = var.environment

  depends_on = [module.lambda_iam_role]
}
