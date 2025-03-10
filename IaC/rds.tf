resource "aws_db_instance" "rds_postgres" {
  allocated_storage      = 10
  db_name                = "mydatabase"
  engine                 = "postgres"
  port                   = 5432
  engine_version         = "16.5" # aws rds describe-db-engine-versions --default-only --engine postgres
  instance_class         = "db.t3.micro"
  username               = var.postgres_username
  password               = var.postgres_credentials.password
  parameter_group_name   = "default.postgres16"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg_rds.id]

  tags = {
    Name = "RDS Postgres"
  }
}