#vpc-vars.tf
vpc_cidr_block = "10.72.0.0/16"
vpc_custom_name = "EICE Project VPC"
vpc_public_rtb_tag = "EICE Project Public Rtb"
vpc_public_sn_tag = "EICE Project Public Subnet"
vpc_private_app_rtb_tag = "EICE Project App Rtb"
vpc_private_app_sn_tag = "EICE Project Private App Subnet"
vpc_private_data_rtb_tag = "EICE Project Data/Database Rtb"
vpc_private_data_sn_tag = "EICE Project Data Subnet"
vpc_nat_gateway_tag = "EICE Project Private NatGW"
vpc_igw_tag = "EICE Project Private NatGW"
vpc_database_subnet_group_name = "eice-project-sn-grp"

#resource aws_ec2_instance_connect_endpoint
eice_tag = "EICE Project EC2 Instance Connect Endpoint"

#sgr-vars.tf
eice_sgr_name = "eice-sgr"
eice_sgr_description = "EICE Project Egress Security Group"
eice_sgr_tag = "EICE Project eice Security Group"

ec2_sgr_name = "ec2-sgr"
ec2_sgr_description = "EICE Project EC2 Ingress Security Group"
ec2_sgr_tag = "EICE Project EC2 Security Group"

#ec2-vars.tf
ec2_instance_name = "jenkins-node"
ec2_instance_type = "t2.micro"
ec2_monitoring = false 
ec2_key_name = "YOUR KEY GOES HERE"
ec2_tag = "EICE Project Jenkins Node"
