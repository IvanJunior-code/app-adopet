resource "aws_instance" "ec2_adopet" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t3.micro"
  key_name      = var.key_name

  user_data = <<-EOF
                sudo apt update && sudo apt-get install nodejs -y && sudo apt install npm -y
                npm install
                npm run build
                npm start:prod
            EOF

  tags = {
    Name = "EC2"
  }
}