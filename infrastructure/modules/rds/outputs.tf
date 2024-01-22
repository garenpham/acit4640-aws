output "a02_rds_ip" {
  value = aws_db_instance.a02_rds.address
}

output "a02_rds_id" {
  value = aws_db_instance.a02_rds.id
}