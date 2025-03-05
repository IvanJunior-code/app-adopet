output "connection_ssh_string" {
  value = "ssh -i ${var.path_key}${var.key_name} ubuntu@${aws_instance.ec2_adopet.public_ip}"
}

output "connections_postgres_string" {
  value = "psql -h ${aws_db_instance.rds_postgres.address} -p ${aws_db_instance.rds_postgres.port} -U ${aws_db_instance.rds_postgres.username} -d ${aws_db_instance.rds_postgres.db_name}"
}
