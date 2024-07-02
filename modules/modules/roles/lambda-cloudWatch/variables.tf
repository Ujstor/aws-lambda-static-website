variable "iam_lambda_cloudwatch_name" {
  description = "Name of the lambda function"
  type        = string
  default     = "iam_for_cloudwatch_lambda"
}

variable "function_name" {
  description = "Name of the lambda function"
  type        = string
}

variable "lambda_iam_role_name" {}
