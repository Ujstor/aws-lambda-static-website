output "public_subnet_ips" {
  description = "EIP for public subnets"
  value       = aws_eip.nat_eip[*].public_ip
}
