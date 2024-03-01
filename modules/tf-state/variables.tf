variable "aws_region" {
  description = "The AWS region in which the S3 bucket will be created"
  type        = string
  default     = "us-east-2" # Replace with your desired region
}

variable "bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state"
  type        = string
  default     = "woo-commerce-terraform-aws-state" # Replace with your bucket name
}

 variable "tags" {
   type = map
   default = {}
 }