module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.environment}-eks"
  cluster_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  
  control_plane_subnet_ids = var.private_subnets

  create_node_security_group = true
  node_security_group_enable_recommended_rules = true
  
  enable_cluster_creator_admin_permissions = true

  subnet_ids = var.private_subnets
  eks_managed_node_groups = {
    main = {
      name           = "${var.environment}-eks-nodes"
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
      ami_type       = var.ami_type

      k8s_labels = {
        Environment = var.environment
        NodeGroup   = "main"
      }
    }
  }
  tags = var.common_tags
}
