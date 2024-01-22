resource "aws_db_instance" "a02_rds" {
  engine                 = "mysql"
  engine_version         = "8.0.34"
  multi_az               = false
  identifier             = "rds-database-instance"
  username               = var.db_username
  password               = var.db_password
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  db_subnet_group_name   = var.a02_db_subnet_group_name
  vpc_security_group_ids = [var.a02_sg_id]
  availability_zone      = "us-west-2a"
  db_name                = "backend"
  skip_final_snapshot    = true
}
