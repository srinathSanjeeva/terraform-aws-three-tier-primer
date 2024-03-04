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

variable "database_address" {
  type = string
  description = "Database address"
  
}

variable "app_port" {
  type = string
  description = "Backend Application port"
  default = "3000"
}

variable "backend_uri" {
  description = "Backend URI"
  type = string
  default = "api/products"  
  
}

variable "backend_subnet_ids"{ 
  description = "Backend Subnet IDs"
  type = map(string)
}
