terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }

  backend "s3" {
    bucket = "laxman-tf-remote-state-prod"
    key = "expense-dev-eks-rds"
    region = "us-east-1"
    dynamodb_table = "laxman-tf-remote-state-prod"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}