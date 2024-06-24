variable "lambda_config" {
  description = "Lambda function configuration"
  type = object({
    work_dir          = string
    bin_name          = string
    archive_bin_name  = string
    handler           = string
    runtime           = string
    ephemeral_storage = number
    archive_type      = string
  })
}

variable "public_url" {
  description = "Public lambda URL for testing"
  type        = bool
  default     = false
}

variable "lambda_iam_role" {}

variable "function_name" {
  description = "Name of the lambda function"
  type        = string
}
