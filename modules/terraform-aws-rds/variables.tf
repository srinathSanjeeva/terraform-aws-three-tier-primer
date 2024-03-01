
variable "db_password" {
  type        = string
  description = "Password for the database"
}


variable "aws_db"{ 
  type = map
  default = {} 
}

variable "default_aws_db"{
  type = map
  default = {
    identifier           = "woo-commerce-database"
    engine               = "mysql"
    instance_class       = "db.t2.micro"
    allocated_storage    = 20
    storage_type         = "gp2"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true
    multi_az             = false
    publicly_accessible  = false
    backup_retention_period = 7
    db_username = "admin"    

  }
}

 variable "tags" {
   type = map
   default = {}   
 }

variable "db_security_group" {
  description = "Database Security Group"
  type = string
}

variable "db_subnet_group_name" {
  description = "Database Subnet Group"
  type = string
}

