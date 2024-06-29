output "vpc_id" {
  description = "VPC id to pass to the module"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "Public subnet ids to pass to the module"
  value       = aws_subnet.public_subnet[*].id
}
