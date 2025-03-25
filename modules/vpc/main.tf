resource "aws_vpc" "internal" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags_vpc
}

# Internet Gateway
resource "aws_internet_gateway" "internal_igw" {
  vpc_id = aws_vpc.internal.id

  tags = var.tags_vpc
}

# Subnets : public
resource "aws_subnet" "public" {
  count                   = length(var.subnets_cidr_public)
  vpc_id                  = aws_vpc.internal.id
  cidr_block              = element(var.subnets_cidr_public, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = count.index == 0 ? true : false

  tags = var.tags_vpc
}

# Subnets : private
resource "aws_subnet" "private" {
  count             = length(var.subnets_cidr_private)
  vpc_id            = aws_vpc.internal.id
  cidr_block        = element(var.subnets_cidr_private, count.index)
  availability_zone = element(var.azs, count.index)

  tags = var.tags_vpc
}

resource "aws_eip" "nateip" {}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = element(aws_subnet.public.*.id, 0) # Single NGW for AZ

  tags = var.tags_vpc
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.internal.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internal_igw.id
  }

  tags = var.tags_vpc
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.internal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = var.tags_vpc
}

resource "aws_route_table_association" "a_public" {
  count          = length(var.subnets_cidr_public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table_association" "a_private" {
  count          = length(var.subnets_cidr_private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "allow_outbound" {
  name        = "allow_outbound"
  description = "Allow TLS outbound traffic"
  vpc_id      = aws_vpc.internal.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.internal.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags_vpc
}