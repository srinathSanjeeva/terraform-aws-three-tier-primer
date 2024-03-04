module "vpc" {
  source              = "../modules/terraform-aws-vpc"
  vpc_id                    = module.vpc.vpc_id
  vpc_cidr                  = var.vpc_cidr
  public_subnet             = var.public_subnet
  private_subnet            = var.private_subnet
  #backend_subnet            = module.vpc.subnet_ids
  database_subnet           = var.database_subnet
  availability_zones        = var.availability_zones
  cidr_block                = var.cidr_block
  route_table_id            = var.route_table_id
  gateway_id                = module.vpc.gateway_id
  #gateway_id                = var.gateway_id
  subnet_id                 = var.subnet_id
  id_app                    = module.backend.id_app
  frontend_id_app           = module.frontend.frontend_id_app
  load_balancer_type        = var.load_balancer_type
  app_alb                   = var.app_alb
  alb_internal              = var.alb_internal
  load_balancer_arn         = var.load_balancer_arn
  alb_listener_port         = var.alb_listener_port
  alb_listener_protocol     = var.alb_listener_protocol
  alb_listener_type         = var.alb_listener_type
  alb_target_group_arn      = var.alb_target_group_arn
  alb_target_group          = var.alb_target_group
  alb_target_group_port     = var.alb_target_group_port
  alb_target_group_protocol = var.alb_target_group_protocol
  app_autoscaling_group     = var.app_autoscaling_group
  frontend_app_autoscaling_group = var.frontend_app_autoscaling_group
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  db_subnet_group_name      = var.db_subnet_group_name
  alb_security_group_name   = var.alb_security_group_name
  app_security_group_name   = var.app_security_group_name
  db_security_group_name    = var.db_security_group_name
  alb_security_group        = module.vpc.alb_security_group
  app_security_group        = var.app_security_group
  front_end_app_security_group_name = var.front_end_app_security_group_name
  tags                = merge(var.tags, { Name = "woo-commerce-terraform-aws-vpc" })
  extra_tags          = var.extra_tags

}

module "db" {
  source      = "../modules/terraform-aws-rds"
  db_password = var.db_password
  #subnet_ids  = module.vpc.private_subnet_id
  #aws_db      = var.aws_db
  db_security_group    = module.vpc.db_security_group
  db_subnet_group_name = module.vpc.aws_db_subnet_group_main
  tags        = merge(var.tags, { Name = "woo-commerce-terraform-aws-db" })
}

module "backend" {
  source = "../modules/terraform-aws-backend"
  tags = merge(var.tags, { Name = "woo-commerce-terraform-aws-backend" })
  image_id           = var.image_id
  instance_type      = var.instance_type
  app_security_group = module.vpc.app_security_group
  name_prefix        = var.name_prefix
  database_address = module.db.database_address
  db_user = module.db.database_username
  db_password = module.db.database_password
  backend_subnet_ids = module.vpc.subnet_ids
  # security_group_id = module.db.database_sg_id
}

module "frontend" {
  source = "../modules/terraform-aws-frontend"
  tags = merge(var.tags, { Name = "woo-commerce-terraform-aws-frontend" })
  image_id           = var.image_id
  instance_type      = var.instance_type
  front_end_app_security_group = module.vpc.front_end_app_security_group
  name_prefix        = var.frontend_name_prefix
  # backend_app_endpoint = data.aws_instances.main.public_ips[0]
  backend_app_endpoint = data.aws_instances.main.public_ips[0]
  backend_app_port = module.backend.backend_app_port
  backend_uri = module.backend.backend_uri

  # Add depends_on to ensure the backend is created first
  depends_on = [module.backend]
}

data "aws_instances" "main" {
  instance_tags = {
    "backend-instance" = "woo-commerce-terraform-aws-backend"
  }
  instance_state_names = ["pending", "running"]
  depends_on = [module.backend]
}

