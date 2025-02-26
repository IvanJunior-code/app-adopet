resource "aws_db_instance" "rds_postgres" {
  allocated_storage    = 10
  db_name              = "postgres"
  engine               = "postgres"
  port                 = 5432
  engine_version       = "16.5" # aws rds describe-db-engine-versions --default-only --engine postgres
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = var.postgres_password
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true
}