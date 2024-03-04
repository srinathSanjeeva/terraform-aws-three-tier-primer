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

variable "name_prefix" {
  description = "Name of Launch Template"
  type    = string
}

variable "front_end_app_security_group" {
  description = "Front End Application Security Group"
  type = string
  
}

variable "backend_app_endpoint" {
  description = "Backend Application Endpoint"
  type = string
}

variable "backend_app_port" {
  description = "Backend Application Port"
  type = string  
}

variable "backend_uri" {
  description = "Backend URI"
  type = string  
  
}
