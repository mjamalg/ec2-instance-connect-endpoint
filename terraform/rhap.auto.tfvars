#rhap-vpc-vars.tf
vpc_cidr_block = "10.72.0.0/16"
vpc_custom_name = "RHAP VPC"
vpc_public_rtb_tag = "RHAP Public Rtb"
vpc_public_sn_tag = "RHAP Public Subnet"
vpc_private_app_rtb_tag = "RHAP Private App Rtb"
vpc_private_app_sn_tag = "RHAP Private App Subnet"
vpc_private_data_rtb_tag = "RHAP Data/Database Rtb"
vpc_private_data_sn_tag = "RHAP Private Data Subnet"
vpc_nat_gateway_tag = "RHAP Private NatGW"
vpc_igw_tag = "RHAP Public IGW"
vpc_database_subnet_group_name = "rhap-sn-grp"

#rhap-ec2-vars.tf
ec2_instance_name = "jenkins-srv"
ec2_instance_type = "t2.micro" 
ec2_tags = "RHAP EC2 Instace"
