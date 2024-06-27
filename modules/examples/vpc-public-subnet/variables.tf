variable "environment" {
  description = "Environment name for lambda"
  type        = string
  default     = "sandbox-vpc"
}

variable "environment_name" {
  description = "Region name for lambda"
  type        = string
  default     = "sandbox-igw-nat-eip"
}

# variable "public_subnet_count" {
#   description = "Number of public subnets"
#   type        = number
#   default     = 3
# }
#
# variable "private_subnet_count" {
#   description = "Number of private subnets"
#   type        = number
#   default     = 3
# }
