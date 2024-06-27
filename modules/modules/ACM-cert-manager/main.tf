resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"

  tags = {
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "cert_arn" {
  description = "Certificate ARN"
  value       = aws_acm_certificate.cert.arn
}
