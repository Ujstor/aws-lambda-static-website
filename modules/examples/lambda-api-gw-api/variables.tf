variable "environment" {
  description = "Environment name for lambda"
  type        = string
  default     = "sandbox-test"
}

variable "sub_account_role_arn" {
  description = "Organization subaccount for testing"
  type        = string
  default     = "arn:aws:iam::730335647984:role/OrganizationAccountAccessRole"
}
