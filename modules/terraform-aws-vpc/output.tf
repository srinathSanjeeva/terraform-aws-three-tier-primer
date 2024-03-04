output "vpc_id" {
  description = "The VPC to be deployed"
  value = aws_vpc.main.id
}

output "gateway_id" {
  description = "Identifier of the VPC Internet Gateway" 
  value = aws_internet_gateway.main.id
}

output "aws_db_subnet_group_main" {
  description = "Database Subnet Group"
  value = aws_db_subnet_group.main.id
}

# # Access the attributes of the subnets using specific instances
output "subnet_ids" {
  value = {
    for key, subnet in aws_subnet.private_subnet : key => subnet.id
  }
}

output "auto_scaling_group" {
  description = "Auto Scaling Group"
  value = aws_autoscaling_group.main.id
}

output "backend_public_ip" {
  value = data.aws_instances.main.public_ips
  #value = data.aws_instances.main.*.public_ips[0]
}

output "front_end_app_security_group" {
  description = "Frontend app Instance Security Group"
  value = aws_security_group.front_end_app_security_group.id
}

output "app_security_group" {
  description = "App Instance Security Group"
  value = aws_security_group.app_security_group.id
}

output "alb_security_group" {
  description = "Application Load Balancer Security Group"
  value = aws_security_group.alb_security_group.id
}

output "db_security_group" {
  description = "Database Security Group"
  value = aws_security_group.db_security_group.id
}
