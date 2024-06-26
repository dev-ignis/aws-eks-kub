locals {
  region = "us-west-2"
}

module "eks" {
  source = "./modules/aws-eks"
}

