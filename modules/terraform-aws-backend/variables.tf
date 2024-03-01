 variable "tags" {
   type = map
   default = {}   
 }


variable "image_id" {
  description = "Image ID"
  type = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type = string
}

variable "app_security_group" {
  description = "Application Security Group"
  type = string
}

variable "name_prefix" {
  description = "Name of Launch Template"
  type    = string
}

variable "database_endpoint" {
  type = string  
}

variable "db_user" {
  type = string
  description = "Username for the database"
}

variable "db_password" {
  type = string
  description = "Password for the database"
}

variable "db_database" {
  type = string
  description = "Database name"
  default = "primer"
}