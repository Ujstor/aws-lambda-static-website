module "vpc_subnets" {
  source = "../../modules/networking/vpc/"

  providers = {
    aws = aws.snadbox
  }

  vpc_name             = var.environment
  name                 = var.environment_name
  public_subnet_count  = 1
  private_subnet_count = 3
}

# module "internt_gw" {
#   source = "../../modules/networking/subnet-public-access/"
#
#   providers = {
#     aws = aws.snadbox
#   }
#
#   name   = var.environment_name
#   vpc_id = module.vpc_subnets
#
#   public_subnets_count = var.public_subnet_count
#   public_subnets_id    = module.vpc_subnets.
#
#   depends_on = [module.vpc_subnets]
# }
