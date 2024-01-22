# Minh Tan Pham A01215507

module "a02_vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = "192.168.0.0/16"
  project_name      = "a02"
  pub_subnet_cidr   = "192.168.2.0/24"
  priv_subnet_cidr  = "192.168.1.0/24"
  rds_cidr          = "192.168.3.0/24"
  home_net          = "24.84.236.0/24"
  bcit_net          = "142.232.0.0/16" 
  aws_region        = "us-west-2"
}

module "a02_pub_sg"{
  source = "./modules/sg"
  sg_name = "a02_pub_sg"
  sg_description = "Allows ssh, web ingress access and all egress"
  project_name = var.project_name
  vpc_id = module.a02_vpc.vpc_id
  ingress_rules = [
    {
      description = "ssh access from home"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.home_net
      rule_name = "ssh_access_home"
    },
    {
      description = "ssh access from bcit"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.bcit_net
      rule_name = "ssh_access_bcit"
    },
    {
      description = "http access from anywhere"
      ip_protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "http_access_from_anywhere"
    },
    {
      description = "https access from anywhere"
      ip_protocol = "tcp"
      from_port = 443
      to_port = 443
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "https_access_from_anywhere"
    }
   ]
  allow_sg_ingress = [
    {
      description = "allow traffic from private sg"
      ip_protocol = "-1"
      from_port = 0
      to_port = 0
      sg_target = module.a02_priv_sg.a02_sg_id
      rule_name = "allow_traffic_from_private_sg"
    }
  ]
  egress_rules = [ 
    {
      description = "allow all egress traffic"
      ip_protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "allow_all_egress"
    }
   ]
}

module "a02_priv_sg"{
  source = "./modules/sg"
  sg_name = "a02_priv_sg"
  sg_description = "Allows ssh, web ingress access and all egress"
  project_name = var.project_name
  vpc_id = module.a02_vpc.vpc_id
  ingress_rules = [
    {
      description = "ssh access from home"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.home_net
      rule_name = "ssh_access_home"
    },
    {
      description = "ssh access from bcit"
      ip_protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_ipv4 = var.bcit_net
      rule_name = "ssh_access_bcit"
    }
   ]
  allow_sg_ingress = [
    {
      description = "allow traffic from public sg"
      ip_protocol = "-1"
      from_port = 0
      to_port = 0
      sg_target = module.a02_pub_sg.a02_sg_id
      rule_name = "allow_traffic_from_public_sg"
    }
  ]
  egress_rules = [ 
    {
      description = "allow all egress traffic"
      ip_protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_ipv4 = "0.0.0.0/0"
      rule_name = "allow_all_egress"
    }
   ]
}

# Use an existing key pair on host machine with file func
# resource "aws_key_pair" "local_key"{
#   key_name = "acit_4640"
#   public_key = file("~/.ssh/acit_4640.pub")
# }

# Create EC2 instance that uses the latest Ubuntu Ami from data
# the local key above
module "a02_web" {
  source = "./modules/ec2"
  project_name = var.project_name
  aws_region = var.aws_region
  ami_id = var.ami_id
  subnet_id = module.a02_vpc.a02_pub_subnet_id
  security_group_id = module.a02_pub_sg.a02_sg_id
  ssh_key_name = var.ssh_key_name
  ec2_name = "a02_web"
}
module "a02_backend" {
  source = "./modules/ec2"
  project_name = var.project_name
  aws_region = var.aws_region
  ami_id = var.ami_id
  subnet_id = module.a02_vpc.a02_priv_subnet_id
  security_group_id = module.a02_priv_sg.a02_sg_id
  ssh_key_name = var.ssh_key_name
  ec2_name = "a02_backend"
}

module "a02_rds" {
  source = "./modules/rds"
  a02_sg_id = module.a02_priv_sg.a02_sg_id
  a02_db_subnet_group_name=module.a02_vpc.a02_db_subnet_group_name
  db_username = var.db_username
  db_password = var.db_password
}


# Write data to file when resources are created
# File will be managed with terraform, deleted when resources are destroyed
resource "local_file" "vpc_vars_file" {
  content=<<-eof
    tf_vpc_id: ${module.a02_vpc.vpc_id}
    tf_a02_web_dns: ${module.a02_web.ec2_instance_public_dns}
    tf_a02_backend_ip: ${module.a02_backend.ec2_instance_private_ip}
    tf_a02_db_ip: ${module.a02_rds.a02_rds_ip}
  eof
  file_permission = "0640"
  filename = "vpc_vars.yaml"
}

resource "local_file" "a02_web_vars" {
  content = <<EOF
---

a02_backend_ip: ${module.a02_backend.ec2_instance_private_ip}

EOF

  filename = "../service/group_vars/a02_web.yml"
}

resource "local_file" "a02_backend_vars" {
  content = <<EOF
---

a02_db_ip: ${module.a02_rds.a02_rds_ip}

EOF

  filename = "../service/group_vars/a02_backend.yml"
}

resource "local_file" "a02_db_vars" {
  content = <<EOF
---

a02_db_ip: ${module.a02_rds.a02_rds_ip}
db_root_pass: ${var.db_password}

EOF

  filename = "../service/group_vars/a02_db.yml"
}

resource "local_file" "script_vars_file" {
  content = <<EOF

a02_web_id="${module.a02_web.ec2_instance_id}"
a02_backend_id="${module.a02_backend.ec2_instance_id}"
a02_db_id="${module.a02_rds.a02_rds_id}"

EOF

  filename = "../script_vars.sh"
}