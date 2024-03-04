data "template_file" "user_data" {
  template = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo service docker start
    touch /home/ec2-user/env.file
    echo "HOST=${var.backend_app_endpoint}" >> /home/ec2-user/env.file
    sudo docker pull sanjeevas/frontend-node-app:1.0
    sudo docker run -e HOST=${var. backend_app_endpoint} -e PORT=${var.backend_app_port} -e URI=${var.backend_uri}  -d -p 80:3000 sanjeevas/frontend-node-app:1.0 
  EOF
}

# Backend application - Launch Template
resource "aws_launch_template" "fronteend_app" {
  name_prefix            = var.name_prefix
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.front_end_app_security_group]
  
  user_data = base64encode(data.template_file.user_data.rendered)


  tags = var.tags
}

