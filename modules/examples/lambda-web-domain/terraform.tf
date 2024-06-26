terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0, < 2.0.0"
}
provider "aws" {
  region = "us-east-1"
  alias  = "sandbox"

  assume_role {
    role_arn = var.sub_account_role_arn
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
