module "lambda" {
  source = "../../modules/lambda/"

  providers = {
    aws = aws.sandbox
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
  lambda_iam_role = module.lambda_iam_role.lambda_iam_role_arn

  depends_on = [module.lambda_iam_role, module.lambda_cloudWatch_iam_role]
}

module "lambda_iam_role" {
  source = "../../modules/roles/lambda-role/"

  providers = {
    aws = aws.sandbox
  }

  iam_lambda_role_name = var.environment
}

module "lambda_cloudWatch_iam_role" {
  source = "../../modules/roles/lambda-cloudWatch/"

  providers = {
    aws = aws.sandbox
  }

  lambda_iam_role_name = module.lambda_iam_role.lambda_iam_role_name

  iam_lambda_cloudwatch_name = var.environment
  function_name              = var.environment

  depends_on = [module.lambda_iam_role]
}
