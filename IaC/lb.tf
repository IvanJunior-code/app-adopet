resource "aws_lb" "alb_adopet" {
  name               = "alb-adopet"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet_lb1.id, aws_subnet.public_subnet_lb2.id]

  enable_deletion_protection = false

  tags = {
    Name = "Application Load Balancer"
  }
}

resource "aws_lb_target_group" "lb_target" {
  name     = "lb-target"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled = true
    path    = "/adotante"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb_adopet.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target.arn
  }
}

data "aws_ami" "data_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${aws_ami_from_instance.adopet_ami.name}"]
  }
}

resource "aws_launch_configuration" "launch_configuration_adopet" {
  name_prefix     = "launch_configuration"
  image_id        = data.aws_ami.data_ami.id
  instance_type   = local.instance_type
  security_groups = [aws_security_group.lb_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling" {
  name                 = "autoscaling"
  max_size             = 3
  min_size             = 1
  desired_capacity     = 1
  force_delete         = true
  launch_configuration = aws_launch_configuration.launch_configuration_adopet.name
  vpc_zone_identifier  = [aws_subnet.public_subnet_lb1.id, aws_subnet.public_subnet_lb2.id]
}

resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling.id
  lb_target_group_arn    = aws_lb_target_group.lb_target.arn
}