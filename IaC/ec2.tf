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
                    aws s3 cp s3://bucket-adopet/adopet-dump /home/ubuntu/sql/adopet-dump.sql
                    chmod 600 /home/ubuntu/sql/adopet-dump.sql
                    chown ubuntu:ubuntu /home/ubuntu/sql/adopet-dump.sql

                    # Baixando e configurando o app
                    mkdir -p /home/ubuntu/app/
                    aws s3 cp s3://bucket-adopet/adopet-app /home/ubuntu/app/app.tar
                    tar -xf /home/ubuntu/app/app.tar -C /home/ubuntu/app/
                    rm -rf /home/ubuntu/app/app.tar
                    chmod 600 /home/ubuntu/app/*
                    chown ubuntu:ubuntu /home/ubuntu/app/*

                    # Restaurando o banco com o arquivo dump .sql
                    PGPASSWORD=$(aws secretsmanager get-secret-value --secret-id adopet-db-password --query SecretString --output text | jq -r .password) pg_restore -v -h ${aws_db_instance.rds_postgres.address} -p ${aws_db_instance.rds_postgres.port} -U ${aws_db_instance.rds_postgres.username} -d ${aws_db_instance.rds_postgres.db_name} /home/ubuntu/sql/adopet-dump.sql 2>/dev/null

                    # Editando arquivo .env para conexão do app com o banco
                    sed -i 's/DB_HOST=db_host_value/DB_HOST=${aws_db_instance.rds_postgres.address}/' /home/ubuntu/app/.env
                    sed -i 's/DB_PORT=db_port_value/DB_PORT=${aws_db_instance.rds_postgres.port}/' /home/ubuntu/app/.env
                    sed -i 's/DB_USERNAME=db_username_value/DB_USERNAME=${aws_db_instance.rds_postgres.username}/' /home/ubuntu/app/.env
                    sed -i 's/DB_PASSWORD=db_password_value/DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id adopet-db-password --query SecretString --output text | jq -r .password)/' /home/ubuntu/app/.env
                    sed -i 's/DB_NAME=db_name_value/DB_NAME=${aws_db_instance.rds_postgres.db_name}/' /home/ubuntu/app/.env

                    # Removendo o AWS CLI
                    sudo rm -rf /usr/local/aws-cli
                    sudo rm -rf /usr/bin/aws
                    sudo rm -rf awscliv2.zip aws

                    # Removendo arquivo dump sql
                    shred -u /home/ubuntu/sql/adopet-dump.sql
                    sudo rm -rf /home/ubuntu/sql/

                    # Criando arquivo de finalização da instalação/configuração
                    touch /tmp/first_setup_done

                    # Executando a aplicação
                    cd /home/ubuntu/app/
                    npm install --force
                    npm run build
                    npm run start:prod

                  } >> $LOG_FILE 2>&1
                fi
                #npm install
                #npm run build
                #npm start:prod
            EOF
  )

  depends_on = [aws_db_instance.rds_postgres, aws_iam_policy_attachment.iam_secretmanager_policy_attachment, aws_iam_policy_attachment.iam_s3_read_policy_attachment, aws_s3_object.object-app]

  tags = {
    Name = "EC2"
  }
}
