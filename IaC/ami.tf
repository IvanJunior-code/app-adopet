resource "aws_ami_from_instance" "adopet_ami" {
  name               = "adopet_ami"
  source_instance_id = aws_instance.ec2_adopet.id

  depends_on = [aws_ssm_association.ssm_association_adopet]

  tags = {
    Name = "AMI Adopet"
  }
}