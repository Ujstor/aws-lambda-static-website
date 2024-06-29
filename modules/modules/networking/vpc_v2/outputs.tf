output "vpcs" {
  description = "VPC Outputs"
  value       = { for vpc in aws_vpc.vpc : vpc.tags.Name => { "cidr_block" : vpc.cidr_block, "id" : vpc.id } }
}

output "subnets_id" {
  description = "Subnet Outputs"
  value       = { for subnet in aws_subnet.subnet : subnet.tags.Name => { "id" : subnet.id } }
}
