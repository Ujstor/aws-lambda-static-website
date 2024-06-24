resource "aws_lambda_function" "lambda" {

  filename         = "${var.lambda_config.work_dir}/${var.lambda_config.archive_bin_name}"
  function_name    = var.function_name
  role             = var.lambda_iam_role
  handler          = var.lambda_config.handler
  runtime          = var.lambda_config.runtime
  source_code_hash = data.archive_file.lambda.output_base64sha256

  ephemeral_storage {
    size = var.lambda_config.ephemeral_storage
  }

  depends_on = [data.archive_file.lambda]
}

resource "aws_lambda_function_url" "url" {
  count              = var.public_url ? 1 : 0
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}

