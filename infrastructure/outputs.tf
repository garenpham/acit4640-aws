# Print out to screen when resources are created
# also when command "terraform output" is run

output "vpc_id" {
  value = module.a02_vpc.vpc_id
}

output "a02_pub_subnet" {
  value = module.a02_vpc.a02_pub_subnet_id
}

output "a02_priv_subnet" {
  value = module.a02_vpc.a02_priv_subnet_id
}

output "a02_igw" {
  value = module.a02_vpc.a02_igw_id
}

output "a02_route" {
  value = module.a02_vpc.a02_route_id
}

# output for EC2 instance ip
output "a02_web_instance_ip_addr" {
  value       = module.a02_web.ec2_instance_public_ip
  description = "The public IP address of the ec2 web instance."
}

output "a02_backend_instance_ip_addr" {
  value       = module.a02_backend.ec2_instance_public_ip
  description = "The public IP address of the ec2 backend instance."
}
output "a02_db_ip" {
  value       = module.a02_rds.a02_rds_ip
  description = "The public IP address of the rds instance."
}