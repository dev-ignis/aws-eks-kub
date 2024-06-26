locals {
  name   = "mht-cluster"

  vpc_cidr = "10.123.0.0/16"
  azs      = ["us-west-2a", "us-west-2b", "us-west-2c"]

  public_subnets  = ["10.123.1.0/24", "10.123.2.0/24", "10.123.3.0/24"]
  private_subnets = ["10.123.4.0/24", "10.123.5.0/24", "10.123.6.0/24"]
  intra_subnets   = ["10.123.7.0/24", "10.123.8.0/24", "10.123.9.0/24"]

  tags = {
    Example = local.name
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8.1"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}


resource "aws_default_security_group" "mht_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}
