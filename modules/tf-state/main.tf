provider "aws" {
  region = var.aws_region # Replace with your desired region
}

# Create an S3 bucket named woo_state_bucket with private access
resource "aws_s3_bucket" "woo_state_bucket" {
  bucket = var.bucket_name # Replace with your bucket name
  #acl    = "private"
  tags   = var.tags

}

# Also enable versioning for the bucket
resource "aws_s3_bucket_versioning" "woo_state_bucket_versioning" {
  bucket = aws_s3_bucket.woo_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
