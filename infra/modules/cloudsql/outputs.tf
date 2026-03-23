output "instance_connection_name" {
  value       = google_sql_database_instance.postgres.connection_name
  description = "Connection name for Cloud SQL instance"
}

output "private_ip_address" {
  value       = google_sql_database_instance.postgres.private_ip_address
  description = "Private IP of Cloud SQL instance"
}

output "db_instance_name" {
  value       = google_sql_database_instance.postgres.name
  description = "Name of the Cloud SQL instance"
}

output "db_user" {
  value       = google_sql_user.app_user.name
  description = "Database user name"
}