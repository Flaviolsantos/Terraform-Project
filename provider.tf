terraform {
    required_version = ">= 0.14"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "3.63.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
    profile = "vocareum"
}