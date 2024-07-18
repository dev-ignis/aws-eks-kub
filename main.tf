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

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count      = length(var.private_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  tags = {
    Name = "${var.cluster_name}-private-subnet-${count.index}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.cluster_name}-public-route-table"
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.25"
  vpc_id          = aws_vpc.main.id
  subnet_ids      = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)

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
