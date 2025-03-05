resource "aws_security_group" "sg_ec2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Security Group SSH"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ssh_rule" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "Ingress SSH Rule"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_dns_rule" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 53
  ip_protocol       = "tcp"
  to_port           = 53

  tags = {
    Name = "Security Group Ingress SSH Rule"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "Egress Rule"
  }
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

  tags = {
    Name = "Ingress RDS Rule"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_rds_rule" {
  security_group_id = aws_security_group.sg_rds.id
  cidr_ipv4         = aws_subnet.public_subnet_ec2.cidr_block
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432

  tags = {
    Name = "Egress RDS Rule"
  }
}
