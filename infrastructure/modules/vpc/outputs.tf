# output vpc id from the module
output "vpc_id" {
  value = aws_vpc.a02_vpc.id
}

output "a02_pub_subnet_id" {
  value = aws_subnet.a02_pub_subnet.id
}

output "a02_pub_subnet_cidr_block" {
  value = aws_subnet.a02_pub_subnet.cidr_block
}

output "a02_priv_subnet_id" {
  value = aws_subnet.a02_priv_subnet.id
}

output "a02_priv_subnet_cidr_block" {
  value = aws_subnet.a02_priv_subnet.cidr_block
}


output "a02_igw_id" {
  value = aws_internet_gateway.a02_igw.id
}

output "a02_route_id" {
  value = aws_route_table.a02_route.id
}

output "a02_db_subnet_group_name" {
  value = aws_db_subnet_group.a02_database_subnet_group.name
}