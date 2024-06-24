data "archive_file" "lambda" {
  type             = var.lambda_config.archive_type
  source_file      = "${var.lambda_config.work_dir}/${var.lambda_config.bin_name}"
  output_path      = "${var.lambda_config.work_dir}/${var.lambda_config.archive_bin_name}"
  output_file_mode = "0666"
}
