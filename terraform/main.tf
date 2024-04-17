terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.45.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


data "aws_eks_cluster" "eks_cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

module "vpc" {
  source = "./modules/vpc" 
  vpc_cidr_block = "10.0.0.0/16"
  public_1_cidr_block = "10.0.1.0/24"
  public_2_cidr_block = "10.0.2.0/24"
  private_1_cidr_block = "10.0.10.0/24"
  private_2_cidr_block = "10.0.11.0/24"
  database_cidr_block_1 = "10.0.20.0/24"
  database_cidr_block_2 = "10.0.21.0/24"
}

module "eks" {
  source = "./modules/eks"
  depends_on = [module.vpc]
  private_subnet_1_id = module.vpc.private_subnet_1
  private_subnet_2_id = module.vpc.private_subnet_2
  cluster_version = "1.28"
}