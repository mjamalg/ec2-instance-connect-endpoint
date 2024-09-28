# Using EC2 Instance Connect Endpoint

### About
This repo is generally used a project source for my private Red Hat Ansible Automation Platform server (RHAAP). There are 2 playbooks that I use to show the RHAAP in action, one to install docker and one to install jenkins. They're located in the "ansible" directory. Feel free to use them with your own RHAAP or just with community ansible. Enjoy!

I recently added some Terraform code that sets up a VPC with my "production ready layout":	
- us-east-1 region
- 10.72.0.0/16 custom VPC CIDR
- 2 Availability Zones (us-east-1a, us-east-1b)
- 3 Subnets in each AZ
    - 1 public
    - 2 private (app and data respectively)
- 1 NAT Gateway 
- 1 Internet Gateway
- 1 public route table
- 1 private route table (for the Nat Gateway)
 
In addition it also creates 2 instances in the "app" private subnets (one in each AZ) and an EC2 Instance Connect Endpoint (EICE) to allow me to ssh to them securely without the need for a bastion host or having to place instances in the public subnet.

My terraform config also create 2 security groups with the AWS recommended ingress and egress ssh rules for the EICE and the E2C instances:

In order to utilize the EICE, I make use of the _aws ec2-instance-connect_ aws cli option with the ssh ProxyCommand like this:
```
ssh ec2-user@i-0123456789example -i mypem.pem -o ProxyCommand='aws ec2-instance-connect open-tunnel --instance-id %h'
```
Replace the i-0123456789example with an instance id, and replace mypem.pem with YOUR EC2 ssh key file. When you run the command you will make an ssh connection!:

### Cost
- NAT Gateway - $0.45 an hour and THERE IS NO FREE TIER (crazy)
- EC2 Instance Connect Endpoint - no extra cost, just standard data transfer rates apply

### Q.E.D
