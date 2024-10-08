# Using EC2 Instance Connect Endpoint

### About
The terraform configs in this repo, most of which were created with the community supported modules, provision a VPC with my "production ready layout":	
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

![eic-project-vpc-readme](https://github.com/user-attachments/assets/6bdfb6ee-e66a-4bf7-959f-c476ee42a797)

They also create an EC2 Instance Connect Endpodint, 2 instances in the "app" private subnet of each AZ, as well as 2 security groups with the AWS recommended ingress and egress ssh rules for both the EICE and the EC2 instances.
![eic-project-sgr-list-readme](https://github.com/user-attachments/assets/9b4c69e8-b0ea-4bdc-9ca3-9f3e0d050255)

What's great about the EC2 Instance Connect Endpoint (EICE) is that it allows secure remote acess to instances in a private subnet without the need for a bastion host or having to place instances in the public subnet!

In order to utilize the EICE, I make use of the _aws ec2-instance-connect_ aws cli option with the ssh ProxyCommand like this:
```
ssh ec2-user@i-0123456789example -i mypem.pem -o ProxyCommand='aws ec2-instance-connect open-tunnel --instance-id %h'
```
Replace the i-0123456789example with an instance id, and replace mypem.pem with YOUR EC2 ssh key file. When you run the command you will make an ssh connection!:
![eic-project-ssh-readm](https://github.com/user-attachments/assets/aa63b643-a938-4d66-85dd-407762355b69)

### Cost
- NAT Gateway - $0.45 an hour and THERE IS NO FREE TIER (crazy)
- EC2 Instance Connect Endpoint - no extra cost, just standard data transfer rates apply

### Q.E.D
