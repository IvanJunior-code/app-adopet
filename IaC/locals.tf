locals {
  region        = "us-east-1"
  instance_type = "t3.micro"
  ami_id        = "ami-04b4f1a9cf54c11d0"
  vpc_cidr      = "10.0.0.0/16"
  subnet1_cidr  = "10.0.1.0/24"
  subnet2_cidr  = "10.0.2.0/24"
}
