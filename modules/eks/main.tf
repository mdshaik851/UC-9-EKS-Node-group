resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids = var.public_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids = var.security_group_ids
  }

  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

resource "aws_eks_node_group" "node_groups" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.medium"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
}

# Datasource: AWS Partition
# Use this data source to lookup information about the current AWS partition in which Terraform is working
data "aws_partition" "current" {}

# Resource: AWS IAM Open ID Connect Provider
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  tags = {
      Name = "${var.name}-eks-irsa"
    }
}

# Extract OIDC Provider from OIDC Provider ARN
locals {
    aws_iam_oidc_connect_provider_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}