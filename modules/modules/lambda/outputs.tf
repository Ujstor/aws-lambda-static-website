output "lambda_arn" {
  description = "Lambda ARN-s and name"
  value = {
    lambda_name = aws_lambda_function.lambda.function_name
    lambda_arn  = aws_lambda_function.lambda.arn
    invoke_arn  = aws_lambda_function.lambda.invoke_arn
  }
}

output "invoke_url" {
  description = "Invoke URL"
  value       = var.public_url ? aws_lambda_function_url.url[0].function_url : ""
}

