terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.0"
    }
  }

  backend "s3" {
    bucket = "laxman-tf-remote-state-prod"
    key = "app-prod-app-alb"
    region = "us-east-1"
    dynamodb_table = "laxman-tf-remote-state-prod"

  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}