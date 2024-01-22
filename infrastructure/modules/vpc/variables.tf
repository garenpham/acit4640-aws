variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "192.168.0.0/16"
}

variable "priv_subnet_cidr" {
  description = "Subnet CIDR"
  default     = "192.168.1.0/24"
}

variable "rds_cidr" {
  description = "RDS CIDR"
  default     = "192.168.3.0/24"
}

variable "pub_subnet_cidr" {
  description = "Subnet CIDR"
  default     = "192.168.2.0/24"
}

variable "default_route"{
  description = "Default route"
  default     = "0.0.0.0/0"
}

variable "home_net" {
  description = "Home network"
  default     = "24.84.236.0/24"
}

variable "bcit_net" {
  description = "BCIT network"
  default     = "142.232.0.0/16"
}
