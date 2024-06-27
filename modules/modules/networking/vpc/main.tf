resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  count             = var.public_subnet_count
  vpc_id            = aws_vpc.name.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.name.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.name.id
#
#   tags = {
#     Name = var.name
#   }
# }
#
# resource "aws_route_table" "public-route-table" {
#   vpc_id = aws_vpc.name.id
#
#   tags = {
#     Name = var.name
#   }
# }
#
# resource "aws_route" "public-route" {
#   route_table_id         = aws_route_table.public-route-table.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }
#
# resource "aws_route_table_association" "public-subnets-association" {
#   count          = var.public_subnet_count
#   subnet_id      = aws_subnet.public_subnet[count.index].id
#   route_table_id = aws_route_table.public-route-table.id
# }
#
# resource "aws_eip" "nat-eip" {
#   domain = "vpc"
#
#   tags = {
#     Name = var.name
#   }
# }
#
# resource "aws_nat_gateway" "nat-gateway" {
#   count         = var.public_subnet_count
#   subnet_id     = aws_subnet.public_subnet[count.index].id
#   allocation_id = aws_eip.nat-eip.id
#
#   tags = {
#     Name = var.name
#   }
# }
#
# resource "aws_security_group" "web-sg" {
#   vpc_id = aws_vpc.name.id
#   name   = var.name
#
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = var.name
#   }
# }
