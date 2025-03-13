resource "aws_ssm_document" "ssm_initialize_adopet" {
  name          = "adopet-initialize"
  document_type = "Command"
  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Configurar serviço Adopet"
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "setupAdopet"
        inputs = {
          runCommand = [
            "echo '${file("../service/adopet-backend.service")}' > /etc/systemd/system/adopet-backend.service",
            "chmod 644 /etc/systemd/system/adopet-backend.service",
            "systemctl daemon-reload",
            "systemctl enable adopet-backend.service",
            "while [ ! -f /tmp/first_setup_done ]; do sleep 1; done",
            "systemctl start adopet-backend.service"
          ]
        }
      }
    ]
  })

  depends_on = [aws_instance.ec2_adopet]
}

resource "aws_ssm_association" "ssm_association_adopet" {
  name = aws_ssm_document.ssm_initialize_adopet.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.ec2_adopet.id]
  }
}