# variables.tf
variable "workspace" {
  description = "The workspace name"
  type        = string

  # Define the possible workspace options
  validation {
    condition     = contains(["test", "staging", "prod"], var.workspace)
    error_message = "Workspace must be one of the following: dev, test, prod."
  }
}

variable "rds_name" {
  description = "The base name for the RDS instance"
  type        = string
}

variable "aws_region_a" {
  description = "AWS region_a"
  type        = string
  default     = "eu-west-1"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage in GB"
  type        = number
  default     = 5
}

variable "max_allocated_storage" {
  description = "The maximum allocated storage in GB"
  type        = number
  default     = 19
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydatabase"
}

variable "db_username" {
  description = "Username for the MSSQL instance"
  type        = string
  default     = "boss_user"
}

variable "vpc_security_group_ids" {
  description = "The VPC Security Group IDs"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The DB subnet group name"
  type        = string
}

variable "major_engine_version" {
  description = "The major engine version for MSSQL"
  type        = string
}

variable "family" {
  description = "The engine family for MSSQL"
  type        = string
}