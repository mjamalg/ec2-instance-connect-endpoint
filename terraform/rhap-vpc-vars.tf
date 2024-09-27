variable "vpc_cidr_block" {
  type = string
}

variable "vpc_custom_name" {
    type = string
}

variable "vpc_public_rtb_tag" {
    type = string
}

variable "vpc_public_sn_tag" {
    type = string
}

variable "vpc_private_app_rtb_tag" {
    type = string 
}

variable "vpc_private_app_sn_tag" {
  
}

variable "vpc_private_data_rtb_tag" {
    type = string
    description = "Custom tag for VPC private data/databse subnets"
}

variable "vpc_private_data_sn_tag" {
    type = string
  
}
variable "vpc_nat_gateway_tag" {
    type = string
    description = "Custom tag for VPC Nat GWs"
}

variable "vpc_igw_tag" {
    type = string
    description = "Custom tag for VPC IGW"
}

variable "vpc_database_subnet_group_name" {
    type = string
    description = "Custom tag for VPC subnets being used for the database cluster"
}