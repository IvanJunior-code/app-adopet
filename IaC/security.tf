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
    Name = "Ingress DNS Rule"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_http_rule" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "Ingress HTTP Rule"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_https_rule" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = "Ingress HTTPS Rule"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_local_dev_rule" {
  security_group_id = aws_security_group.sg_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000

  tags = {
    Name = "Ingress Local Dev Rule"
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
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432

  tags = {
    Name = "Ingress RDS Rule"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_rds_rule" {
  security_group_id = aws_security_group.sg_rds.id
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432

  tags = {
    Name = "Egress RDS Rule"
  }
}

resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Security Group Load Balancer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_lb_rule" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "Ingress Load Balancer HTTP Rule"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_lb_rule" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "Egress Load Balancer Rule"
  }
}

resource "aws_security_group" "instances_sg" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Security Group Instances"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_instances_for_lb_rule" {
  security_group_id = aws_security_group.instances_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000

  tags = {
    Name = "Ingress Rule Instances for Load Balancer"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_instances_for_lb_rule" {
  security_group_id = aws_security_group.instances_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "Egress Rule Instances for Load Balancer"
  }
}