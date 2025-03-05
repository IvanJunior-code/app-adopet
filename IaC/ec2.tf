resource "aws_instance" "ec2_adopet" {
  ami           = local.ami_id
  instance_type = local.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public_subnet_ec2.id
  # security_groups = [aws_security_group.sg_ssh.id] # security_groups is used for default VPC only
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  user_data = base64encode(<<-EOF
                #!/bin/bash
                LOG_FILE="/var/log/user_data.log"
                if [ ! -f /tmp/first_setup_done ]; then
                  {
                    sudo apt update && sudo apt-get install nodejs npm postgresql-client-16 -y
                    touch /tmp/first_setup_done
                  } >> $LOG_FILE 2>&1
                fi
                #npm install
                #npm run build
                #npm start:prod
            EOF
  )

  tags = {
    Name = "EC2"
  }
}