output "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_role_arn" {
  description = "EKS Cluster IAM Role ARN"
  value       = module.eks.cluster_iam_role_arn
}

output "eks_cluster_security_group_id" {
  description = "EKS Cluster Security Group ID"
  value       = module.eks.cluster_security_group_id
}
