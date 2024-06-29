variable "vpc_name" {
  description = "Environment name for vpc"
  type        = string
  default     = "sandbox-vpc"
}

variable "sub_account_role_arn" {
  description = "Organization subaccount for testing"
  type        = string
  default     = "arn:aws:iam::730335647984:role/OrganizationAccountAccessRole"
}

variable "environment" {
  description = "Region name for lambda"
  type        = string
  default     = "sandbox-igw-nat-eip"
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 3
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 3
}
