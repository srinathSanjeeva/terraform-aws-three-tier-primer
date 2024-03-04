locals {

  ingress_rules = [{
    port        = 80
    description = "Allow HTTP access"
    },
    {
      port        = 443
      description = "Allow HTTPS access"
    },
    # {
    #   port        = 3000
    #   description = "Allow Backend Script access"
    #   },
    {
      port        = 22
      description = "Allow SSH access"
  }]

  backend_app_ingress_rules = [{
    port            = 3000
    description     = "Allow Backend Node JS Script access"
  },
  {
    port        = 22
    description = "Allow SSH access"
  }]

  rds_ingress_rules = [{
    port            = 3306
    description     = "Allow MySQL access"
  }]

  egress_rules = [{
     port        = 0
    description = "Allow all Egress traffic"
  }]
}

################################################################################
# VPC
################################################################################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(var.tags, { Name = "VPC" })
}

#Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = var.vpc_id
  for_each                = var.public_subnet
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = "true" #makes this a public subnet

  tags = merge(var.tags, { Name = "public-subnet" })
}

#Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = var.vpc_id
  for_each          = var.private_subnet
  availability_zone = each.key
  cidr_block        = each.value

  tags = merge(var.tags, { Name = "private-subnet" })
}

#Database Subnet
resource "aws_subnet" "database_subnet" {
  vpc_id            = var.vpc_id
  for_each          = var.database_subnet
  availability_zone = each.key
  cidr_block        = each.value

  tags = merge(var.tags, { Name = "database-subnet" })
}

#Internet Gateway for the Public Subnet
resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, { Name = "internet-gateway" })
}

#Route Table for the Internet Gateway / Public Subnet
resource "aws_route_table" "main" {
  vpc_id = var.vpc_id
  for_each = var.public_subnet

  route {
    cidr_block             = var.cidr_block
    gateway_id             = var.gateway_id
  }

  tags = merge(var.tags, { Name = "public-route-table" })
}

#Route table associations - Public
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.public_subnet[each.key].id
  for_each       = var.public_subnet
  route_table_id = aws_route_table.main[each.key].id
}

#Application Load Balancer
resource "aws_lb" "main" {
  name               = var.app_alb
  internal           = var.alb_internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.alb_security_group]
  subnets            = [for value in aws_subnet.public_subnet : value.id]

  tags = merge(var.tags, { Name = "application-alb" })
}

#Application Load Balancer Listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol

  default_action {
    type             = var.alb_listener_type
    target_group_arn = aws_lb_target_group.main.arn
  }
}

#Application Load Balancer Target Group
resource "aws_lb_target_group" "main" {
  name     = var.alb_target_group
  port     = var.alb_target_group_port
  protocol = var.alb_target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    protocol  = var.alb_target_group_protocol
    port     = var.alb_target_group_port
  }
}

#Auto Scaling Group
resource "aws_autoscaling_group" "main" {
  name                = var.app_autoscaling_group
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = [aws_lb_target_group.main.arn]

  vpc_zone_identifier = [for value in aws_subnet.public_subnet : value.id]

  launch_template {
    id      = var.id_app
    version = "$Latest"
  }

  # tag = var.tags

  dynamic "tag" {
    for_each = var.extra_tags
    content {
      key                 = tag.value.key
      propagate_at_launch = tag.value.propagate_at_launch
      value               = tag.value.value
    }
  }  
}

data "aws_instances" "main" {
  filter{
    # Create a filter based on subnet id
    name   = "subnet-id"
    values = [for value in aws_subnet.private_subnet : value.id]
  }
  # instance_ids = aws_autoscaling_group.main.ec2_instance_ids 
}

resource "aws_autoscaling_group" "frontend" {
  name                = var.frontend_app_autoscaling_group
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = [aws_lb_target_group.main.arn]

  vpc_zone_identifier = [for value in aws_subnet.public_subnet : value.id]

  launch_template {
    id      = var.frontend_id_app
    version = "$Latest"
  }
}

# Database Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = var.db_subnet_group_name
  subnet_ids = [for value in aws_subnet.database_subnet : value.id]

  tags = merge(var.tags, { Name = "database-subnet-group" })
}

################################################################################
# ALB - Security Group
################################################################################
resource "aws_security_group" "alb_security_group" {
  name        = var.alb_security_group_name
  description = "Security Group for Application Load Balancer"
  vpc_id      = var.vpc_id

    dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]

    }
  }

  dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]

    }
  }

  tags = merge(var.tags, { Name = "alb-security-group" })
}

################################################################################
# Frontend - Security Group
################################################################################
resource "aws_security_group" "front_end_app_security_group" {
  name        = var.front_end_app_security_group_name
  description = "Security Group for frontend Host"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
      security_groups = [var.alb_security_group]

    }
  }

  dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]

    }
  }

  tags = merge(var.tags, { Name = "frontend-security-group" })
}


################################################################################
# Applications - Security Group
################################################################################
resource "aws_security_group" "app_security_group" {
  name        = var.app_security_group_name
  description = "Security Group for backend Host"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.backend_app_ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
      security_groups = [aws_security_group.front_end_app_security_group.id]

    }
  }

  dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]

    }
  }

  tags = merge(var.tags, { Name = "backend-security-group" })
}

################################################################################
# RDS - Security Group
################################################################################

resource "aws_security_group" "db_security_group" {
  name        = var.db_security_group_name
  description = "Security Group for RDS MySQL Database"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.rds_ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      security_groups = [aws_security_group.app_security_group.id]

    }
  }

  dynamic "egress" {
    for_each = local.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = "-1"
      cidr_blocks = [var.cidr_block]

    }
  }

  tags = merge(var.tags, { Name = "rds-security-group" })
}
