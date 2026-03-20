output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.cluster.id
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "Certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.cluster.name
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.nodes.arn
}