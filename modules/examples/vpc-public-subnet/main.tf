module "vpc_subnets" {
  source = "../../modules/networking/vpc/"

  providers = {
    aws = aws.snadbox
  }

  vpc_name             = var.environment
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

module "public_subnets_igw" {
  source = "../../modules/networking/public-subnet/"

  providers = {
    aws = aws.snadbox
  }

  name = var.environment_name

  vpc_id               = module.vpc_subnets.vpc_id
  public_subnets_id    = module.vpc_subnets.public_subnet_ids
  public_subnets_count = var.public_subnet_count

  depends_on = [module.vpc_subnets]
}

module "nat_eip" {
  source = "../../modules/networking/nat-eip/"

  providers = {
    aws = aws.snadbox
  }

  name                 = var.environment_name
  public_subnets_count = var.public_subnet_count

  vpc_id            = module.vpc_subnets.vpc_id
  public_subnets_id = module.vpc_subnets.public_subnet_ids

  depends_on = [module.public_subnets_igw]
}
