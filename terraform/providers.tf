terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = " YOUR AWS PROFILE GOES HERE IF YOU USE ENV VARIABLES LIKE ME "

  #Add your AWS credential information here if you don't use a profile

}
