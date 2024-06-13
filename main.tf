provider "aws" {
    region = "us-east-1"  
}
variable "cidr" {
  description = "CIDR for VPC"
}
variable "cluster_name" {
  description = "EKS Cluster name"
}

module "aws_eks" {
  source = "./modules/aws_eks"
  cidr = var.cidr
  cluster_name = var.cluster_name
}