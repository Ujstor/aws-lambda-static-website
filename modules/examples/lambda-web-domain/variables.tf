variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone id"
  type        = string
}

variable "environment" {
  description = "Environment name for lambda"
  type        = string
  default     = "sandbox-test"
}

variable "domain" {
  description = "Domain name for lambda"
  type        = string
  default     = "lambda-test.ujstor.com"
}
