output "CNAME_records" {
  value = [
    for dvo in tolist(aws_acm_certificate.cert.domain_validation_options) : {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
    }
  ]
}

output "certificate_arn" {
  description = "Certificate ARN"
  value       = aws_acm_certificate.cert.arn
}
