terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
  }

  backend "s3" {
    bucket = "laxman-tf-remote-state-prod"
    key = "web_app-prod-acm"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}