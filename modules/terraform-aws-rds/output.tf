output "database_endpoint" {
  value       = aws_db_instance.woo_commerce_db.endpoint
  description = "Endpoint of the created database"
}

output "database_address" {
  value       = aws_db_instance.woo_commerce_db.address
  description = "Endpoint of the created database"
}

output "database_username" {
  value       = aws_db_instance.woo_commerce_db.username
  description = "Username for the created database"
}

output "database_password" {
  value       = var.db_password
  description = "Password for the created database"
}

# Output the ARN of the created SSM parameter
output "ssm_parameter_arn" {
  value = aws_ssm_parameter.db_password.arn
}