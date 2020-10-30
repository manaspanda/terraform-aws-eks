terraform {
  required_version = ">= 0.12"
}

# AWS providers
provider "aws" {
  version = "~> 2.0"
  profile = var.aws_profile
  region  = var.region
}