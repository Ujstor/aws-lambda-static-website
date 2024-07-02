output "lambda_iam_role__arn" {
  description = "Lambda IAM role ARNe"
  value       = aws_iam_role.iam_for_lambda.arn
}


output "lambda_iam_role_name" {
  description = "Lambda IAM role ARNe"
  value       = aws_iam_role.iam_for_lambda.name
}
