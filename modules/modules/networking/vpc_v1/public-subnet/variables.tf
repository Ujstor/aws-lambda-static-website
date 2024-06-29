variable "vpc_id" {
  description = "VPC id to connect internet gateway to"
}

variable "name" {
  description = "Name of internet gateway"
  type        = string
}

variable "public_subnets_id" {
  description = "Public subnets id to associate with route table"
}

variable "public_subnets_count" {
  description = "Number of public subnets to associate with route table"
  type        = number
}
