module "network" {
  source = "./modules/network"

  cluster_name   = var.cluster_name
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

# Create EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.25"
  vpc_id          = module.network.vpc_id
  subnet_ids      = concat(module.network.public_subnet_ids, module.network.private_subnet_ids)

  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
      instance_type    = var.instance_type
    }
  }

  tags = {
    Environment = "dev"
    Name        = var.cluster_name
  }
}
