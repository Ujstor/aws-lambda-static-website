module "vpc_subnets" {
  source = "../../../modules/networking/vpc_v1/vpc/"

  providers = {
    aws = aws.snadbox
  }

  vpc_name             = var.vpc_name
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

module "public_subnets_igw" {
  source = "../../../modules/networking/vpc_v1/public-subnet/"

  providers = {
    aws = aws.snadbox
  }

  name = var.environment

  vpc_id               = module.vpc_subnets.vpc_id
  public_subnets_id    = module.vpc_subnets.public_subnet_ids
  public_subnets_count = var.public_subnet_count

  depends_on = [module.vpc_subnets]
}

# module "nat_eip" {
#   source = "../../../modules/networking/vpc_v1/nat-eip/"
#
#   providers = {
#     aws = aws.snadbox
#   }
#
#   name                 = var.environment_name
#   public_subnets_count = var.public_subnet_count
#
#   vpc_id            = module.vpc_subnets.vpc_id
#   public_subnets_id = module.vpc_subnets.public_subnet_ids
#
#   depends_on = [module.public_subnets_igw]
# }

resource "aws_eip" "nat_eip" {
  provider = aws.snadbox

  domain = "vpc"

  tags = {
    Name = var.environment
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  provider = aws.snadbox

  subnet_id     = module.vpc_subnets.public_subnet_ids[0]
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = var.environment
  }
}


resource "aws_security_group" "web_sg" {
  provider = aws.snadbox

  vpc_id = module.vpc_subnets.vpc_id
  name   = var.environment

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.environment
  }
}
