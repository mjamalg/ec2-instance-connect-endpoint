data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


module "eic_sgr" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"
 
  name        = "rhap-eic-sgr"
  description = "Egress sgr for EIC Endpoint"
  vpc_id      = module.vpc.vpc_id

  egress_cidr_blocks = [var.vpc_cidr_block]
}

module "ec2_sgr" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "rhap-eic-sgr"
  description = "Ingress EC2 sgr"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule = "ssh-tcp"
      source_security_group_id = module.eic_sgr.security_group_id 
    },
  ]
}


module "jenkins_master" {
  source  = "terraform-aws-modules/ec2-instance/aws"

   name = "jenkins-master"
  ami  = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  key_name               = "NewA4L"
  monitoring             = false
  subnet_id              = element(module.vpc.private_subnets, 0) 
  vpc_security_group_ids = [ module.ec2_sgr.security_group_id]
  tags = {
    Name = "RHAP Jenkins Master"
  }
}

module "jenkins_node" {
  source  = "terraform-aws-modules/ec2-instance/aws"

   name = "jenkins-node"
  ami                    = data.aws_ami.amazon_linux_2.id 
  instance_type          = "t2.micro"
  key_name               = "NewA4L"
  monitoring             = false
  subnet_id              = element(module.vpc.private_subnets, 1)
  vpc_security_group_ids = [ module.eic_sgr.security_group_id ]
  tags = {
     Name = "RHAP Jenkins Node"
  }
}

resource "aws_ec2_instance_connect_endpoint" "rhap-endpoint" {
  subnet_id = element(module.vpc.private_subnets, 0)
  security_group_ids = toset([module.eic_sgr.security_group_id])
  
  tags = {
    Name = "RHAP EC2 Instance Connect Endpoint"
  }
}