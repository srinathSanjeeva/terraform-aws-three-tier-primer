output "database_endpoint" {
  value       = aws_db_instance.woo_commerce_db.endpoint
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

