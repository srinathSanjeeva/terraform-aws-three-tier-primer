data "template_file" "user_data" {
  template = <<-EOF
    #!/bin/bash
    export DB_PASSWORD="${var.db_password}"
    sudo yum update -y
    sudo yum install docker -y
    sudo service docker start
    sudo docker pull sanjeevas/backend-node-app:10.0
    sudo docker run -e DB_HOST=${var.database_endpoint} -e DB_USER=${var.db_user} -e DB_PASSWORD=${var.db_password} -e DB_NAME=${var.db_database} -d -p 80:3000 sanjeevas/backend-node-app:10.0 
  EOF
}

# Backend application - Launch Template
resource "aws_launch_template" "main" {
  name_prefix            = var.name_prefix
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.app_security_group]
  
    user_data = base64encode(data.template_file.user_data.rendered)


  tags = var.tags
}