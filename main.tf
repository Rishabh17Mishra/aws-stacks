# Generate a secure random password for the RDS instance
resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "_%@!" # MSSQL-safe special characters
}

# Create AWS Secrets Manager Secret to store RDS credentials
resource "aws_secretsmanager_secret" "rds_secret" {
  name        = var.rds_name
  description = "Credentials for MSSQL RDS instance"
}

# Store Username and Auto-Generated Password in AWS Secrets Manager
resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.rds_password.result
  })
}

# RDS MSSQL Module Using Auto-Generated Password from Secrets Manager
module "rds_mssql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier           = "${terraform.workspace}-${var.rds_name}"  # Dynamic RDS name based on workspace
  engine               = "sqlserver-se"
  engine_version       = "15.00.4236.7.v1"
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  db_name              = var.db_name
  major_engine_version = var.major_engine_version
  family = var.family

  username = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_version.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_version.secret_string)["password"]

  publicly_accessible   = false
  multi_az             = false
  storage_encrypted    = true
  backup_retention_period = 7
  skip_final_snapshot  = true

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name

  tags = {
    Name        = "${terraform.workspace}-MSSQL-RDS"  # Tag with workspace name
    Environment = terraform.workspace
  }
}

# Data block to retrieve Secret from AWS Secrets Manager
data "aws_secretsmanager_secret" "rds_secret" {
  name = aws_secretsmanager_secret.rds_secret.name
}

data "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}