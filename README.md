# Using EC2 Connect Interface Endpoint

I generally use this repo as a project source for my private Red Hat Ansible Automation Platform server. I've recently added some Terraform code that sets up an EC2 Connect Interface Endpoint in a VPC that allows me to ssh remotely to an EC2 instance without the use of a bastion host. 

This Terraform configs in the terraform directory provide the following:
- VPC with 2 availability zones in us-east-1a and us-east-1b
- 1 NAT Gateway
- 1 Internet Gateway
- 1 EIC
- 2 EC2 Instances, one in each AZ
- security groups with ingress and egress rules from the EIC to the EC2 instances.

In this way I can run my playbooks remotely without using a bastion host!
