resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet_ec2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${local.region}a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_rds_1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${local.region}b"
  cidr_block        = "10.0.2.0/24"
}

resource "aws_subnet" "private_subnet_rds_2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${local.region}c"
  cidr_block        = "10.0.3.0/24"
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

resource "aws_security_group" "sg_ssh" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Security Group SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_rule" {
  security_group_id = aws_security_group.sg_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.sg_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "sg_dns" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Security Group Rule"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_dns_rule" {
  security_group_id = aws_security_group.sg_dns.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 53
  ip_protocol       = "tcp"
  to_port           = 53
}

resource "aws_security_group" "sg_rds" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Security Group RDS"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rds_rule" {
  security_group_id = aws_security_group.sg_rds.id
  cidr_ipv4         = aws_subnet.public_subnet_ec2.cidr_block
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "egress_rds_rule" {
  security_group_id = aws_security_group.sg_rds.id
  cidr_ipv4         = aws_subnet.public_subnet_ec2.cidr_block
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}