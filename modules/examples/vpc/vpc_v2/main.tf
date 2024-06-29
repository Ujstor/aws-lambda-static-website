locals {
  vpc_id              = ["vpc_1", "vpc_2"]
  public_subnet_ids   = ["pub_subnet_1", "pub_subnet_2", "pub_subnet_3"]
  private_subnet_ids  = ["priv_subnet_1", "priv_subnet_2", "priv_subnet_3"]
  internet_gateway_id = ["igw_1", "igw_2"]
  route_table_id      = ["rt_1", "rt_2"]
}

module "vpc_v2" {
  source = "../../../modules/networking/vpc_v2/"

  providers = {
    aws = aws.snadbox
  }

  vpc_parameters = {
    (local.vpc_id[0]) = {
      cidr_block           = var.vpc_cidr_block[0]
      enabled_dns_support  = true
      enable_dns_hostnames = true

      tags = {
        Name = var.environment
      }
    }
  }

  subnet_parameters = {
    (local.public_subnet_ids[0]) = {
      cidr_block = var.public_subnet_cidr_blocks[0]
      vpc_name   = local.vpc_id[0]

      tags = {
        Name = var.environment
      }
    }
    (local.public_subnet_ids[1]) = {
      cidr_block = var.public_subnet_cidr_blocks[1]
      vpc_name   = local.vpc_id[0]

      tags = {
        Name = var.environment
      }
    }
    (local.public_subnet_ids[2]) = {
      cidr_block = var.public_subnet_cidr_blocks[2]
      vpc_name   = local.vpc_id[0]

      tags = {
        Name = var.environment
      }
    }
    (local.private_subnet_ids[0]) = {
      cidr_block = var.private_subnet_cidr_blocks[0]
      vpc_name   = local.vpc_id[0]

      tags = {
        Name = var.environment
      }
    }
    (local.private_subnet_ids[1]) = {
      cidr_block = var.private_subnet_cidr_blocks[1]
      vpc_name   = local.vpc_id[0]

      tags = {
        Name = var.environment
      }
    }
    (local.private_subnet_ids[2]) = {
      cidr_block = var.private_subnet_cidr_blocks[2]
      vpc_name   = local.vpc_id[0]

      tags = {
        Name = var.environment
      }
    }
  }

  igw_parameters = {
    (local.internet_gateway_id[0]) = {
      vpc_name = local.vpc_id[0]

      tags = {
        Name = var.environment
      }
    }
  }

  rt_parameters = {
    (local.route_table_id[0]) = {
      vpc_name = local.vpc_id[0]

      tags = {
        Name = var.environment
      }

      routes = [
        {
          cidr_block = "0.0.0.0/0"
          use_igw    = true
          gateway_id = local.internet_gateway_id[0]
        }
      ]
    }
  }

  rt_association_parameters = {
    rap_1 = {
      subnet_name = local.public_subnet_ids[0]
      rt_name     = local.route_table_id[0]
    }
    rap_2 = {
      subnet_name = local.public_subnet_ids[1]
      rt_name     = local.route_table_id[0]
    }
    rap_3 = {
      subnet_name = local.public_subnet_ids[2]
      rt_name     = local.route_table_id[0]
    }
  }
}

resource "aws_security_group" "web_sg" {
  provider = aws.snadbox

  vpc_id = module.vpc_v2.vpcs[local.vpc_id[0]].id
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


resource "aws_eip" "nat_eip" {
  provider = aws.snadbox
  domain   = "vpc"

  tags = {
    Name = var.environment
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  provider = aws.snadbox

  subnet_id     = module.vpc_v2.subnets_id[local.public_subnet_ids[0]].id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = var.environment
  }

  depends_on = [module.vpc_v2]
}
