resource "aws_key_pair" "acesso_ec2" {
  key_name   = var.key_name
  public_key = var.public_key
}