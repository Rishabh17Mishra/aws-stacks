output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds_mssql.db_instance_endpoint
}

output "secrets_manager_arn" {
  description = "AWS Secrets Manager ARN storing RDS credentials"
  value       = aws_secretsmanager_secret.rds_secret.arn
}

output "db_password" {
  description = "The auto-generated password (not recommended to output in production)"
  value       = random_password.rds_password.result
  sensitive   = true
}
