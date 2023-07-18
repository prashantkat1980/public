terraform {
    required_version = ">=0.14.9"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>4.67"
        }
    }
    backend "s3"{
       bucket = "prashant-dev-bucket-testing"
      key="ecr/DEV/prashantecr.tfstate" 
    }
}
# configure aws provider 
provider "aws" {    
    region = "us-east-1"
}