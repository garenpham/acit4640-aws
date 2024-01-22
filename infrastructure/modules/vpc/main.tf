# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "a02_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name="a02_vpc"
    Project = var.project_name
  }
}

# Create a public subnet
# To use the free tier t2.micro ec2 instance you have to declare an AZ
# Some AZs do not support this instance type
resource "aws_subnet" "a02_pub_subnet" {
  vpc_id                  = aws_vpc.a02_vpc.id
  cidr_block              = var.pub_subnet_cidr
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags={
    Name="a02_pub_subnet"
    Project = var.project_name
  }
}

# Create a private subnet
resource "aws_subnet" "a02_priv_subnet" {
  vpc_id            = aws_vpc.a02_vpc.id
  cidr_block        = var.priv_subnet_cidr
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "a02_priv_subnet"
    Project = var.project_name
  }
}

# Create a rds subnet
resource "aws_subnet" "a02_rds_subnet" {
  vpc_id            = aws_vpc.a02_vpc.id
  cidr_block        = var.rds_cidr
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "a02_rds_subnet"
    Project = var.project_name
  }
}

# Create internet gateway for VPC
resource "aws_internet_gateway" "a02_igw" {
  vpc_id=aws_vpc.a02_vpc.id

  tags = {
    Name="a02_igw"
    Project = var.project_name
  }
}

# Create route table for web VPC
resource "aws_route_table" "a02_route" {
  vpc_id=aws_vpc.a02_vpc.id

  tags = {
    Name="a02_route"
    Project = var.project_name
  }
}

# Add route to route table
resource "aws_route" "pub_default_route" {
  route_table_id = aws_route_table.a02_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.a02_igw.id
}

# Associate a02 route table with a02 public subnet
resource "aws_route_table_association" "a02_route_table_pub_association" {
  subnet_id = aws_subnet.a02_pub_subnet.id
  route_table_id = aws_route_table.a02_route.id
}

# Associate a02 route table with a02 private subnet
resource "aws_route_table_association" "a02_route_table_priv_association" {
  subnet_id = aws_subnet.a02_priv_subnet.id
  route_table_id = aws_route_table.a02_route.id
}

# Associate a02 route table with a02 rds subnet
resource "aws_route_table_association" "a02_route_table_rds_association" {
  subnet_id = aws_subnet.a02_rds_subnet.id
  route_table_id = aws_route_table.a02_route.id
}

# create the subnet group for the rds instance
resource "aws_db_subnet_group" "a02_database_subnet_group" {
  name        = "a02_rds_subnet_group"
  subnet_ids  = [aws_subnet.a02_priv_subnet.id, aws_subnet.a02_rds_subnet.id]
  description = "Subnet group for RDS database"
  
  tags = {
    Name = "database_subnet_group"
  }
}
