module "lambda-website" {
  source = "../../modules/services/lambda-web-domain/"

  environment = "stage"
  go_bin_dir  = "../go-lambda-code/complete-website/"

  cloudflare_zone_id   = var.cloudflare_zone_id
  cloudflare_api_token = var.cloudflare_api_token

  domain           = "ujstor.com"
  lambda_func_name = "lambda-website"
}

