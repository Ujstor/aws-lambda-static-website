output "pub_subnet_ips" {
  description = "public subnet ips"
  value       = aws_eip.nat_eip.public_ip
}
