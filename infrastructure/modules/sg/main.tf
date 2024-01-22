resource "aws_security_group" "a02_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  tags = {
    Name    = var.sg_name
    Project = var.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each          = {
    for index, rule in var.ingress_rules: 
    rule.rule_name => rule
  }

  description       = each.value.description
  ip_protocol       = each.value.ip_protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4         = each.value.cidr_ipv4
  security_group_id = aws_security_group.a02_sg.id
  tags = {
    Name    = each.value.rule_name
    Project = var.project_name
  }
}

resource "aws_security_group_rule" "allow_sg_ingress" {
  for_each          = {
    for index, rule in var.allow_sg_ingress: 
    rule.rule_name => rule
  }

  type                     = "ingress"
  description              = each.value.description
  protocol                 = each.value.ip_protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  source_security_group_id = each.value.sg_target
  security_group_id = aws_security_group.a02_sg.id
}

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  for_each          = {
    for index, rule in var.egress_rules: 
    rule.rule_name => rule
  }

  security_group_id = aws_security_group.a02_sg.id
  ip_protocol       = each.value.ip_protocol
  cidr_ipv4         = each.value.cidr_ipv4
  tags = {
    Name    = each.value.rule_name
    Project = var.project_name
  }
}