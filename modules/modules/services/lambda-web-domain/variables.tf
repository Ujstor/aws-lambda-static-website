variable "environment" {
  description = "Environment name for lambda"
  type        = string
}

variable "lambda_func_name" {
  description = "Lambda function name"
  type        = string
  default     = "lambda-web-deployment"
}

variable "go_bin_dir" {
  description = "Dir where go complied website binaries is located"
  type        = string
}

variable "domain" {
  description = "Domain name for api-gw"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone id"
  type        = string
}
