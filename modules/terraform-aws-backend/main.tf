# Ideally, should be getting the password from Kubernetes secret, but since this is a demo, we are passing it as a variable.
data "template_file" "user_data" {
  template = <<-EOF
    #!/bin/bash
    export DB_PASSWORD="${var.db_password}"
    sudo yum update -y
    sudo yum install docker -y
    sudo service docker start
    touch /home/ec2-user/env.file
    echo "DB_HOST=${var.database_address}" >> /home/ec2-user/env.file
    echo "DB_USER=${var.db_user}" >> /home/ec2-user/env.file
    echo "DB_NAME=${var.db_database}" >> /home/ec2-user/env.file
    echo "DB_PASSWORD=${var.db_password}" >> /home/ec2-user/env.file
    sudo docker pull sanjeevas/backend-node-app:latest
    sudo docker run --env-file /home/ec2-user/env.file -d -p ${var.app_port}:3000 sanjeevas/backend-node-app:latest
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

