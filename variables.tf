variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
    default     = "my-eks-cluster"
}

variable "region" {
    description = "AWS region"
    type        = string
    default     = "us-east-2"
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnets" {
    description = "List of public subnet CIDR blocks"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
    description = "List of private subnet CIDR blocks"
    type        = list(string)
    default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "desired_capacity" {
    description = "Desired number of worker nodes"
    type        = number
    default     = 2
}

variable "max_capacity" {
    description = "Maximum number of worker nodes"
    type        = number
    default     = 3
}

variable "min_capacity" {
    description = "Minimum number of worker nodes"
    type        = number
    default     = 1
}

variable "instance_type" {
    description = "EC2 instance type for the worker nodes"
    type        = string
    default     = "t3.medium"
}
