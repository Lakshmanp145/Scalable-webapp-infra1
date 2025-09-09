
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.95.0"
    }
  }
   backend "s3" {
    bucket = "laxman-tf-remote-state-prod"
    key = "web_app-prod-eks"
    region = "us-east-1"
    dynamodb_table = "laxman-tf-remote-state-prod"

  }
}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}