output "connection_ssh_string" {
  value = "ssh -i ${var.path_key}${var.key_name} ubuntu@${aws_instance.ec2_adopet.public_ip}"
}

output "endpoint_rds" {
  value = aws_db_instance.rds_postgres.endpoint
}