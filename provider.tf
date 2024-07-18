provider "aws" {
  region = var.region
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.31.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }

  required_version = "~> 1.3"
}
