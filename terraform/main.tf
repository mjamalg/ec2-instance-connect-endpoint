locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "eice_sgr" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.eice_sgr_name
  description = var.eice_sgr_description
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = [var.vpc_cidr_block]
  ingress_rules            = ["ssh-tcp"]
  egress_with_source_security_group_id = [
    {
      rule = "ssh-tcp"
      source_security_group_id = module.ec2_sgr.security_group_id 
    },   
  ]

  tags = {
    Name = var.eice_sgr_tag
  }
}

module "ec2_sgr" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.ec2_sgr_name
  description = var.eice_sgr_description
  vpc_id      = module.vpc.vpc_id

  egress_cidr_blocks = [ var.vpc_cidr_block ]
  ingress_with_source_security_group_id = [
    {
      rule = "ssh-tcp"
      source_security_group_id = module.eice_sgr.security_group_id 
    },
  ]
  
  tags = {
    Name = var.ec2_sgr_tag
  }
}

resource "aws_ec2_instance_connect_endpoint" "eice-endpoint" {
  subnet_id             = element(module.vpc.private_subnets, 0)
  security_group_ids    = toset([module.eice_sgr.security_group_id])
  
  tags = {
    Name = var.eice_tag
  }
}

module "jenkins_master" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["1", "2"])  

  name                      = format("${var.ec2_instance_name}-%s", each.key)
  ami                       = data.aws_ssm_parameter.latest_amazon_linux2_ami.value
  instance_type             = var.ec2_instance_type
  key_name                  = var.ec2_key_name
  monitoring                = var.ec2_monitoring
  subnet_id                 = element(module.vpc.private_subnets, tonumber(each.key)-1) 
  vpc_security_group_ids    = [ module.ec2_sgr.security_group_id]

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_custom_name
  cidr = var.vpc_cidr_block

  azs               = local.azs
  public_subnets    = [ for k,v in local.azs : cidrsubnet(var.vpc_cidr_block, 4, k)   ]
  private_subnets   = [ for k,v in local.azs : cidrsubnet(var.vpc_cidr_block, 4, k+3) ]
  database_subnets  = [ for k,v in local.azs : cidrsubnet(var.vpc_cidr_block, 4, k+6) ]
  
  enable_nat_gateway        = true
  single_nat_gateway        = true
  one_nat_gateway_per_az    = false
  nat_gateway_tags          = { Name = var.vpc_nat_gateway_tag }
   
  create_igw    = true # default but put here for readability
  igw_tags      = { Name = var.vpc_igw_tag }

  enable_dns_hostnames  = true
  enable_dns_support    = true

  #What I Dont Want/Need  
  enable_vpn_gateway                = false 
  manage_default_vpc                = false
  manage_default_network_acl        = false
  manage_default_route_table        = false
  manage_default_security_group     = false
  create_elasticache_subnet_group   = false

  #Names and Tags
  public_subnet_names       = [ for k,v in local.azs : format("${var.vpc_custom_name}-pub-%s",split("-",v)[2]) ]
  public_route_table_tags   = { Name = var.vpc_public_rtb_tag }

  private_subnet_names      = [ for k,v in local.azs : format("${var.vpc_custom_name}-priv-app-%s",split("-",v)[2]) ]
  private_route_table_tags  = { Name = var.vpc_private_app_rtb_tag }
 
  database_subnet_names         = [ for k,v in local.azs : format("${var.vpc_custom_name}-priv-data-%s",split("-",v)[2]) ]
  database_route_table_tags     = { Name = var.vpc_private_data_rtb_tag }
  database_subnet_group_tags    = { Name = var.vpc_private_data_sn_tag } 
  database_subnet_group_name    = var.vpc_database_subnet_group_name
}