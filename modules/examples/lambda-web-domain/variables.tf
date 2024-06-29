variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "sub_account_role_arn" {
  description = "Organization subaccount for testing"
  type        = string
  default     = "arn:aws:iam::730335647984:role/OrganizationAccountAccessRole"
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
