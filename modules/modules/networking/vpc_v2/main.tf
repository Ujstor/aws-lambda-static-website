resource "aws_vpc" "vpc" {
  for_each             = var.vpc_parameters
  cidr_block           = each.value.cidr_block
  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames
  tags = merge(each.value.tags, {
    Name : each.key
  })
}

resource "aws_subnet" "subnet" {
  for_each   = var.subnet_parameters
  vpc_id     = aws_vpc.vpc[each.value.vpc_name].id
  cidr_block = each.value.cidr_block
  tags = merge(each.value.tags, {
    Name : each.key
  })
}

resource "aws_internet_gateway" "igw" {
  for_each = var.igw_parameters
  vpc_id   = aws_vpc.vpc[each.value.vpc_name].id
  tags = merge(each.value.tags, {
    Name : each.key
  })
}

resource "aws_route_table" "rt" {
  for_each = var.rt_parameters
  vpc_id   = aws_vpc.vpc[each.value.vpc_name].id
  tags = merge(each.value.tags, {
    Name : each.key
  })

  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.use_igw ? aws_internet_gateway.igw[route.value.gateway_id].id : route.value.gateway_id
    }
  }
}

resource "aws_route_table_association" "rta" {
  for_each       = var.rt_association_parameters
  subnet_id      = aws_subnet.subnet[each.value.subnet_name].id
  route_table_id = aws_route_table.rt[each.value.rt_name].id
}
