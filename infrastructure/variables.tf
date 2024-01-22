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
  description = "Private Subnet CIDR"
  default     = "192.168.1.0/24"
}

variable "pub_subnet_cidr" {
  description = "Public Subnet CIDR"
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

variable "ssh_key_name"{
  description = "AWS SSH key name"
  default = "acit_4640"
}

variable "ami_id" {
  description = "AMI ID"
}

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