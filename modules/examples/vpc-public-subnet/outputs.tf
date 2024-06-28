output "pub_subnet_ips" {
  description = "public subnet ips"
  value       = module.nat_eip.public_subnet_ips
}
