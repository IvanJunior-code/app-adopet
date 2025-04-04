resource "null_resource" "app_tar" {

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
        mkdir -p ../app-tar
        tar -cf ../app-tar/app.tar ../src ../package*.json ../tsconfig*.json ../.env
    EOT
  }
}

resource "null_resource" "validate_app_ready" {
  triggers = {
    instance_ip = aws_instance.ec2_adopet.public_ip
  }

  provisioner "local-exec" {
    command = <<EOT
      # Loop to wait for API to return HTTP 200
      # It will be a sign about user_data completed successfully

      while true; do
        echo "Checking http://${aws_instance.ec2_adopet.public_ip}:3000/adotante"
        STATUS=$(curl -s -o /dev/null -w "%%{http_code}" "http://${aws_instance.ec2_adopet.public_ip}:3000/adotante" || true)
        
        if [ "$STATUS" = "200" ]; then
          echo "API responding HTTP $STATUS!"
          break
        else
          echo "Waiting API (status $STATUS)..."
          sleep 10
        fi
      done
    EOT
  }

  depends_on = [aws_instance.ec2_adopet]
}