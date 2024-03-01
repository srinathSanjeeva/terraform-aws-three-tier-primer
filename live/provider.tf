# Define Terraform backend using a S3 bucket for storing the Terraform state
terraform {
  backend "s3" {
    bucket = "woo-commerce-terraform-aws-state"
    key    = "live/dev/woo-commerce/terraform.tfstate"
    region = "us-east-2"
  }
}