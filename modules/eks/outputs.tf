output "cluster_arn" {
  value = aws_eks_cluster.cluster.arn
}

output "node_group_arn" {
  value = aws_eks_node_group.node_groups.arn
}

# Output: AWS IAM Open ID Connect Provider
output "aws_iam_openid_connect_provider_extract_from_arn" {
  description = "AWS IAM Open ID Connect Provider extract from ARN"
   value = local.aws_iam_oidc_connect_provider_extract_from_arn
}

# Output: AWS IAM Open ID Connect Provider ARN
output "aws_iam_openid_connect_provider_arn" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value = aws_iam_openid_connect_provider.oidc_provider.arn 
}

# EKS Cluster Outputs
output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = aws_eks_cluster.cluster.id
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = aws_eks_cluster.cluster.version
}



output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by the EKS cluster. Referred to as 'Cluster security group' in the EKS console."
  value       = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}

# EKS Node Group Outputs - Private
output "node_group_public_id" {
  description = "Public Node Group ID"
  value       = aws_eks_node_group.node_groups.id
}

output "node_group_public_arn" {
  description = "Public Node Group ARN"
  value       = aws_eks_node_group.node_groups.arn
}

output "node_group_public_status" {
  description = "Public Node Group status"
  value       = aws_eks_node_group.node_groups.status 
}

output "node_group_public_version" {
  description = "Public Node Group Kubernetes Version"
  value       = aws_eks_node_group.node_groups.version
}
