locals {
  cluster_name = "education-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "eks" {
  source = "./modules/aws-eks"
}

/* deployments */
module "nginx" {
  source = "./deploy/nginx"
}
