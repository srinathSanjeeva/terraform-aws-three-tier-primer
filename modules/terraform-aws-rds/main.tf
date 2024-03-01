resource "aws_db_instance" "woo_commerce_db" {
  identifier           = lookup(var.aws_db, "identifier", var.default_aws_db["identifier"])
  engine               = lookup(var.aws_db, "engine", var.default_aws_db["engine"])
  instance_class       = lookup(var.aws_db, "instance_class", var.default_aws_db["instance_class"])
  allocated_storage    = lookup(var.aws_db, "allocated_storage", var.default_aws_db["allocated_storage"])
  storage_type         = lookup(var.aws_db, "storage_type", var.default_aws_db["storage_type"])
  username             = lookup(var.aws_db, "db_username", var.default_aws_db["db_username"])
  password             = var.db_password
  parameter_group_name = lookup(var.aws_db, "parameter_group_name", var.default_aws_db["parameter_group_name"])
  skip_final_snapshot  = lookup(var.aws_db, "skip_final_snapshot", var.default_aws_db["skip_final_snapshot"])

  vpc_security_group_ids = [var.db_security_group]

  db_subnet_group_name = var.db_subnet_group_name

  multi_az               = lookup(var.aws_db, "multi_az", var.default_aws_db["multi_az"])
  publicly_accessible   = lookup(var.aws_db, "publicly_accessible", var.default_aws_db["publicly_accessible"])
  backup_retention_period = lookup(var.aws_db, "backup_retention_period", var.default_aws_db["backup_retention_period"])


  tags = var.tags
}

