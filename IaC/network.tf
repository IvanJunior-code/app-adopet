resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet_ec2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${local.region}a"
  cidr_block              = local.subnet_public_cidr
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_rds_1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${local.region}b"
  cidr_block        = local.subnet_private1_cidr
}

resource "aws_subnet" "private_subnet_rds_2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${local.region}c"
  cidr_block        = local.subnet_private2_cidr
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet"
  subnet_ids = [aws_subnet.private_subnet_rds_1.id, aws_subnet.private_subnet_rds_2.id]

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Route Table"
  }
}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public_subnet_ec2.id
  route_table_id = aws_route_table.route_table.id
}
