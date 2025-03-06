resource "aws_instance" "ec2_adopet" {
  ami           = local.ami_id
  instance_type = local.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public_subnet_ec2.id
  # security_groups = [aws_security_group.sg_ssh.id] # security_groups is used for default VPC only
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  provisioner "file" {
    source = "../sql/adopet-dump.sql"
    destination = "/home/ubuntu/adopet-dump.sql"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("${var.path_key}${var.key_name}")
      host = self.public_ip
    }
  }

  user_data = base64encode(<<-EOF
                #!/bin/bash
                LOG_FILE="/var/log/user_data.log"
                if [ ! -f /tmp/first_setup_done ]; then
                  {
                    # Instalação do nodejs npm e postgres-client
                    sudo apt update && sudo apt-get install nodejs npm postgresql-client-16 -y

                    # Restaurando o banco com o arquivo dump .sql
                    PGPASSWORD="${aws_db_instance.rds_postgres.password}" pg_restore -v -h ${aws_db_instance.rds_postgres.address} -p ${aws_db_instance.rds_postgres.port} -U ${aws_db_instance.rds_postgres.username} -d ${aws_db_instance.rds_postgres.db_name} adopet-dump.sql

                    # Criando arquivo de finalização da instalação/configuração
                    touch /tmp/first_setup_done
                  } >> $LOG_FILE 2>&1
                fi
                #npm install
                #npm run build
                #npm start:prod
            EOF
  )

  depends_on = [ aws_db_instance.rds_postgres ]

  tags = {
    Name = "EC2"
  }
}
