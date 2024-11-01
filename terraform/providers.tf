terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.13.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" 
    }
  }
}

provider "aws" {
  region  = var.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint                 
  cluster_ca_certificate = base64decode(module.eks.cluster_ca)         
  token                  = module.eks.auth_token    
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = module.eks.auth_token
    cluster_ca_certificate = base64decode(module.eks.cluster_ca)
  }
}
