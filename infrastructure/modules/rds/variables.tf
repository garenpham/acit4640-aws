variable "db_password" {
  description = "RDS user password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "RDS user name"
  type        = string
  sensitive   = true
}

variable "a02_db_subnet_group_name" {
  description = "RDS subnet group"
  default     = "a02_rds_subnet_group"
}

variable "a02_sg_id" {
  description = "Security Group ID"
  type        = string
}