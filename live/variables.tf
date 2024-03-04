variable "tags" {
  type = map(any)
  default = {
    Name        = "woo-commerce-terraform-aws"
    Environment = "dev"
    Project     = "woo-commerce-project"
  }
}

variable "vpc_id"  {
    description = "The VPC to be deployed"
    type = string
    default = "aws_vpc.main.id"
}

variable "vpc_cidr" {
  description = "The VPC Network Range"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet" {
  description = "A list of public subnets inside the VPC"
  type = map(string)
    default     = {
        "us-east-2a" = "10.0.0.0/24",
        "us-east-2b" = "10.0.1.0/24",
        "us-east-2c" = "10.0.2.0/24"
  }
}

variable "private_subnet" {
  description = "A list of private subnets inside the VPC"
  type = map(string)
  default = {
  "us-east-2a" = "10.0.101.0/24",
  "us-east-2b" = "10.0.102.0/24",
  "us-east-2c" = "10.0.103.0/24"
  }
}

variable "database_subnet" {
  description = "A list of database subnets inside the VPC"
  type = map(string)
  default = {
  "us-east-2a" = "10.0.201.0/24",
  "us-east-2b" = "10.0.202.0/24",
  "us-east-2c" = "10.0.203.0/24"
  }
}

variable "availability_zones" {
  description = "Availability Zones used"
  type = list(string)
  default = [
  "us-east-2a",
  "us-east-2b",
  "us-east-2c"
  ]
}

variable "cidr_block" {
  description = "CIDR Block to allow traffic via"
  type = string
  default = "0.0.0.0/0"
}

variable "route_table_id" {
  description = "The ID of the Routing Table"
  type = string
  default = "aws_route_table.main[each.key].id"
}
# TODO should be each of the id.
  
variable "gateway_id" {
  description = "Identifier of the VPC Internet Gateway"
  type = string
  default = "aws_internet_gateway.main.id"
}

variable "subnet_id" {
  description =  "subnet ID which resources will be launched in"
  type = string
  default = "aws_subnet.public_subnet.id"
}

variable "load_balancer_type" {
  description = "The type of load balancer to be deployed"
  type = string
  default = "application"
}

variable "app_alb" {
  description = "The name of the Application Load Balancer"
  type = string
  default = "app-alb"
}

variable "alb_internal" {
  description = "Boolean to create an internal load balancer"
  type = string
  default =   "false"
}

variable "load_balancer_arn" {
  description = "The ARN of the Load Balancer"
  type = string
  default = "aws_lb.main.arn"
}

variable "alb_listener_port" {
  description = "The port for the Load Balancer Listener"
  type = string
  default = "80"
}

variable "alb_listener_protocol" {
  description = "The protocol for the Load Balancer Listener"
  type = string
  default = "HTTP"
}

variable "alb_listener_type" {
  description = "The type of Load Balancer Listener"
  type = string
  default = "forward"
}

variable "alb_target_group_arn" {
  description = "The ARN of the Load Balancer Target Group"
  type = string
  default = "aws_lb_target_group.main.arn"
}

variable "alb_target_group" {
  description = "The name of the Load Balancer Target Group"
  type = string
  default = "alb-target-group"
}

variable "alb_target_group_port" {
  description = "The port for the Load Balancer Target Group"
  type = string
  default = "80"
}

variable "alb_target_group_protocol" {
  description = "The protocol for the Load Balancer Target Group"
  type = string
  default = "HTTP"
}

variable "app_autoscaling_group" {
  description = "The name of the Application Autoscaling Group"
  type = string
  default = "app-autoscaling-group"
}

variable "frontend_app_autoscaling_group" {
  description = "The name of the Application Autoscaling Group"
  type = string
  default = "frontend-app-autoscaling-group"
}

variable "desired_capacity" {
  description = "The desired capacity of the Autoscaling Group"
  type = string
  default = "1"
}

variable "max_size" {
  description = "The maximum size of the Autoscaling Group"
  type = string
  default = "1"
}

variable "min_size" {
  description = "The minimum size of the Autoscaling Group"
  type = string
  default = "1"
}

variable "db_subnet_group_name" {
  description = "The name of the Database Subnet Group"
  type = string
  default = "db-subnet-group"
}

variable "alb_security_group_name" {
  description = "The name of the Application Load Balancer Security Group"
  type = string
  default = "alb-app-security-group"
}

variable "front_end_app_security_group_name" {
  description = "The name of the Application Security Group"
  type = string
  default = "frontend-instance-security-group"
}

variable "app_security_group_name" {
  description = "The name of the Application Security Group"
  type = string
  default = "app-instance-security-group"
}

variable "db_security_group_name" {
  description = "The name of the Database Security Group"
  type = string
  default = "db-security-group"
}

variable "alb_security_group" {
  description = "The Application Load Balancer Security Group"
  type = string
  default = "aws_security_group.alb_security_group.id"
}

variable "app_security_group" {
  description = "The Application Security Group"
  type = string
  default = "aws_security_group.app_security_group.id"
}


variable "db_password" {
  type        = string
  description = "Password for the database"
}

################################################################################
# Backend Module - Variables 
################################################################################

variable "image_id" {
  description = "Image ID"
  type        = string
  default     = "ami-02ca28e7c7b8f8be1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "name_prefix" {
  description = "Name of Launch Template"
  type        = string
  default     = "app-launch-template"
}

variable "frontend_name_prefix" {
  description = "Name of frontend Launch Template"
  type        = string
  default     = "frontend-app-launch-template"
}

variable "id_app" {
  description = "Launch Template ID"
  type        = string
  default     = "aws_launch_template.main.id"
}

variable "extra_tags" {
  default = [
    {
      key                 = "backend-instance"
      value               = "woo-commerce-terraform-aws-backend"
      propagate_at_launch = true
    }
  ]
}