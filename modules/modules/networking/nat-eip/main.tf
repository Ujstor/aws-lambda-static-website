resource "aws_eip" "nat-eip" {
  domain = "vpc"

  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  count         = var.public_subnets_count
  subnet_id     = var.public_subnets_id[count.index].id
  allocation_id = aws_eip.nat-eip.id

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "web-sg" {
  vpc_id = var.vpc_id
  name   = var.name

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
    Name = var.name
  }
}
