terraform {
  backend "s3" {
    bucket = "terraform-state-bryn-test"
    key    = "AWS-Basic-Web-Hosting-Terraform"
    region = "us-east-1"

  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}
