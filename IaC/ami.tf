resource "aws_ami_from_instance" "adopet_ami" {
  name                    = "adopet_ami"
  snapshot_without_reboot = false
  source_instance_id      = aws_instance.ec2_adopet.id


  depends_on = [
    null_resource.validate_app_ready
  ]

  tags = {
    Name = "AMI Adopet"
  }
}