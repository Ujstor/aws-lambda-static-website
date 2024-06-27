module "lambda-website" {
  source = "../../modules/services/lambda-web-domain/"

  providers = {
    aws = aws.sandbox
  }

  environment = var.environment
  go_bin_dir  = "../go-lambda-code/complete-website/"

  cloudflare_zone_id   = var.cloudflare_zone_id
  cloudflare_api_token = var.cloudflare_api_token

  domain           = var.domain
  lambda_func_name = var.environment
}
