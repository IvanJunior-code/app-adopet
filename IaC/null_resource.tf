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