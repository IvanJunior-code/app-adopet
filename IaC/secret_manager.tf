resource "aws_secretsmanager_secret" "secretmanager_postgres" {
  name                    = "adopet-db-password"
  recovery_window_in_days = 0

  tags = {
    Name = "Secret Manager"
  }
}

resource "aws_secretsmanager_secret_version" "credentials_versions" {
  secret_id     = aws_secretsmanager_secret.secretmanager_postgres.id
  secret_string = jsonencode(var.postgres_credentials)
}

# Comando para forçar exclusão de secret que foi deletada e se encontra na retenção
# aws secretsmanager delete-secret --secret-id adopet-db-password --force-delete-without-recovery
