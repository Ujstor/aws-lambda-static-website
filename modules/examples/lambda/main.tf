module "lambda_web" {
  source = "../../modules/lambda/"

  providers = {
    aws = aws.snadbox
  }

  lambda_config = {
    work_dir          = "../go-lambda-code/naked-lambda/"
    bin_name          = "bootstrap"
    archive_bin_name  = "function.zip"
    handler           = "main"
    runtime           = "provided.al2023"
    ephemeral_storage = "512"
    archive_type      = "zip"
  }

  function_name   = var.environment
  public_url      = true
  lambda_iam_role = module.lambda_iam_role.lambda_iam_role__arn
}

module "lambda_iam_role" {
  source = "../../modules/roles/lambda-role/"

  providers = {
    aws = aws.snadbox
  }

  iam_lambda_role_name = var.environment
}
