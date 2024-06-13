terraform {
  backend "s3" {
    bucket = "sanjkaki-terraform"
    key = "sanjkaki/terraform.tfstate"
    region = "us-east-1"
    
  }
}