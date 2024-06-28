resource "aws_eip" "nat-eip" {
  count  = var.public_subnets_count
  domain = "vpc"

  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  count         = var.public_subnets_count
  subnet_id     = var.public_subnets_id[count.index]
  allocation_id = aws_eip.nat-eip[count.index].id

  tags = {
    Name = var.name
  }
}
