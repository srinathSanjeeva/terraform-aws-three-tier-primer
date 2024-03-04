output "id_app" {
  description = "Launch Template ID"
  value = aws_launch_template.main.id
}

# # Output the public IP of the EC2 instance
# output "instance_public_ips" {
#   value = {
#     for key, instance in aws_instance.main : key => instance.public_ip
#   }
# }

# output "backend_public_ip" {
#   value = aws_instance.main.public_ip  # Placeholder for public IP
# }

output "backend_app_port" {
  description = "Backend Application port"
  value = var.app_port
}

output "backend_uri" {
  description = "Backend URI"
  value = var.backend_uri
}