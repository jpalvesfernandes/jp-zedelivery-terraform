provider "aws" {
  region  = var.region
  version = "~> 3.00"
}


terraform {
  backend "s3" {
    bucket = "jp-zedelivery-test-tfstate"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}