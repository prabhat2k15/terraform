terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }

  required_version = "~> 1.0"
}


terraform {
  backend "s3" {
    bucket         = "terraform-rebid"
    key            = "eks/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-backend-lock-s3"
  }
}


provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = module.eks.cluster_arn
  }

  #   # localhost registry with password protection
  #   registry {
  #     url = "oci://localhost:5000"
  #     username = "username"
  #     password = "password"
  #   }

  #   # private registry
  #   registry {
  #     url = "oci://private.registry"
  #     username = "username"
  #     password = "password"
  #   }
}