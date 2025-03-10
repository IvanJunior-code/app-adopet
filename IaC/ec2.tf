resource "aws_instance" "ec2_adopet" {
  ami           = local.ami_id
  instance_type = local.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public_subnet_ec2.id
  # security_groups = [aws_security_group.sg_ssh.id] # security_groups is used for default VPC only
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  iam_instance_profile = aws_iam_instance_profile.iam_instance_profile.name

  user_data = base64encode(<<-EOF
                #!/bin/bash
                LOG_FILE="/var/log/user_data.log"
                if [ ! -f /tmp/first_setup_done ]; then
                  {
                    # Instalação do nodejs, npm, postgres-client e unzip
                    sudo apt-get update && sudo apt-get install nodejs npm postgresql-client-16 unzip jq -y

                    # Instalação da AWS CLI
                    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                    unzip awscliv2.zip
                    sudo ./aws/install

                    # Baixando e configurando o arquivo dump sql
                    mkdir -p /home/ubuntu/sql/
                    aws s3 cp s3://bucket-adopet-dump-sql/adopet-dump /home/ubuntu/sql/adopet-dump.sql
                    chmod 600 /home/ubuntu/sql/adopet-dump.sql
                    chown ubuntu:ubuntu /home/ubuntu/sql/adopet-dump.sql

                    # Recuperando senha para acesso ao banco de dados
                    PASSWORD=$(aws secretsmanager get-secret-value --secret-id adopet-db-password --query SecretString --output text | jq -r .password)

                    # Restaurando o banco com o arquivo dump .sql
                    PGPASSWORD=$PASSWORD pg_restore -v -h ${aws_db_instance.rds_postgres.address} -p ${aws_db_instance.rds_postgres.port} -U ${aws_db_instance.rds_postgres.username} -d ${aws_db_instance.rds_postgres.db_name} /home/ubuntu/sql/adopet-dump.sql

                    # Removendo o AWS CLI
                    sudo rm -rf /usr/local/aws-cli
                    sudo rm -rf /usr/bin/aws
                    sudo rm -rf awscliv2.zip aws

                    # Removendo arquivo dump sql
                    shred -u /home/ubuntu/sql/adopet-dump.sql
                    sudo rm -rf /home/ubuntu/sql/

                    # Criando arquivo de finalização da instalação/configuração
                    touch /tmp/first_setup_done
                  } >> $LOG_FILE 2>&1
                fi
                #npm install
                #npm run build
                #npm start:prod
            EOF
  )

  depends_on = [aws_db_instance.rds_postgres, aws_iam_policy_attachment.iam_secretmanager_policy_attachment, aws_iam_policy_attachment.iam_s3_read_policy_attachment]

  tags = {
    Name = "EC2"
  }
}
