variable "environment" {
  description = "Environment name for vpc"
  type        = string
  default     = "sandbox-vpc_v2"
}

variable "sub_account_role_arn" {
  description = "Organization subaccount for testing"
  type        = string
  default     = "arn:aws:iam::730335647984:role/OrganizationAccountAccessRole"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
  ]
}
