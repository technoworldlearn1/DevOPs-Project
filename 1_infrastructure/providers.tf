
# This file contains the AWS providers details
# This is a sample file, in actual implemenation, we will install AWS CLI and will configure secret key and access key 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

  
}

