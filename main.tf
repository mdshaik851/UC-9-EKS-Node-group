module "vpc" {
  source = "./modules/vpc"
  region = var.region
  vpc_cidr = var.vpc_cidr
  public_subnet = var.public_subnet
  availability_zone = var.availability_zone
  private_subnet = var.private_subnet
}

module "iam" {
  source = "./modules/iam"
  name = var.name
  aws_iam_openid_connect_provider_arn = module.eks_cluster.aws_iam_openid_connect_provider_arn
  aws_iam_openid_connect_provider_extract_from_arn = module.eks_cluster.aws_iam_openid_connect_provider_extract_from_arn
}

module "eks_cluster" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  k8s_version = var.k8s_version
  eks_node_role_arn = module.iam.eks_node_role_arn
  node_group_name = var.node_group_name
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_id
  security_group_ids = [module.vpc.security_group_eks_cluster]
  eks_oidc_root_ca_thumbprint = var.eks_oidc_root_ca_thumbprint
  name = var.name
}

module "ecr-eks" {
  source = "./modules/ecr"
  repository_name = var.repository_name
}

module "helm" {
  source = "./modules/helm"
  cluster_id = module.eks_cluster.cluster_id
  cluster_endpoint = module.eks_cluster.cluster_endpoint
  cluster_certificate_authority_data = module.eks_cluster.cluster_certificate_authority_data
  lbc_iam_depends_on = module.iam.lbc_iam_depends_on
  lbc_iam_role_arn   = module.iam.lbc_iam_role_arn
  vpc_id             = module.vpc.vpc_id_details
  aws_region         = var.region
}




# module "vpc" {
#   source = "./modules/vpc"

#   project_name          = var.project_name
#   vpc_cidr             = var.vpc_cidr
#   public_subnet_cidrs  = var.public_subnet_cidrs
#   private_subnet_cidrs = var.private_subnet_cidrs
#   azs                  = var.azs
# }

# module "iam" {
#   source = "./modules/iam"

#   project_name = var.project_name
# }

# module "eks" {
#   source = "./modules/eks"

#   project_name                             = var.project_name
#   cluster_name                            = "${var.project_name}-cluster"
#   k8s_version                             = var.k8s_version
#   subnet_ids                              = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
#   eks_cluster_role_arn                    = module.iam.eks_cluster_role_arn
#   eks_node_role_arn                       = module.iam.eks_node_role_arn
#   eks_cluster_policy_attachment           = module.iam.eks_cluster_policy_attachment
#   eks_service_policy_attachment           = module.iam.eks_service_policy_attachment
#   eks_vpc_resource_controller_policy_attachment = module.iam.eks_vpc_resource_controller_policy_attachment
#   eks_worker_node_policy_attachment       = module.iam.eks_worker_node_policy_attachment
#   eks_cni_policy_attachment               = module.iam.eks_cni_policy_attachment
#   ec2_container_registry_read_policy_attachment = module.iam.ec2_container_registry_read_policy_attachment

#   node_groups = {
#     main = {
#       desired_size    = 2
#       max_size       = 4
#       min_size       = 1
#       instance_types = ["t3.medium"]
#       capacity_type  = "ON_DEMAND"
#       disk_size      = 20
#     }
#   }
# }

# module "ecr" {
#   source = "./modules/ecr"

#   repository_names = ["app-frontend", "app-backend", "app-worker"]
# }

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#   }
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "aws"
#       args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#     }
#   }
# }