resource "aws_iam_role" "iam_for_lambda" {
  name               = var.iam_lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json

  inline_policy {}
}
