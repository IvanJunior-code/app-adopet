resource "aws_instance" "ec2_adopet" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t3.micro"
  key_name        = var.key_name
  subnet_id       = aws_subnet.public_subnet1.id
  security_groups = [aws_security_group.sg_ssh.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update && sudo apt-get install nodejs -y && sudo apt install npm -y
                sudo apt install postgresql-client-16 -y
                #npm install
                #npm run build
                #npm start:prod
            EOF

  tags = {
    Name = "EC2"
  }
}