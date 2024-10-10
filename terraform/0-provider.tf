terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">3.51.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">3.1.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
