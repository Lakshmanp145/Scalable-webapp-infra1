terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {
    bucket = "laxman-tf-remote-state-prod"
    key = "web-_app-prod-sg"
    region = "us-east-1"
    dynamodb_table = "laxman-tf-remote-state-prod"

  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}