variable "vpc_cidr_block" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}
variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/24",
    "10.0.10.0/24",
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24",
    "10.0.14.0/24",
    "10.0.15.0/24",
    "10.0.16.0/24",
    "10.0.17.0/24",
    "10.0.18.0/24",
    "10.0.19.0/24",
    "10.0.20.0/24",
    "10.0.21.0/24",
    "10.0.22.0/24",
    "10.0.23.0/24",
    "10.0.24.0/24"

  ]
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24",
    "10.0.109.0/24",
    "10.0.110.0/24",
    "10.0.111.0/24",
    "10.0.112.0/24",
    "10.0.113.0/24",
    "10.0.114.0/24",
    "10.0.115.0/24",
    "10.0.116.0/24",
    "10.0.117.0/24",
    "10.0.118.0/24",
    "10.0.119.0/24",
    "10.0.120.0/24",
    "10.0.121.0/24",
    "10.0.122.0/24",
    "10.0.123.0/24",
    "10.0.124.0/24",
  ]
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
}

variable "name" {
  description = "Name of internet gateway"
  type        = string
}
