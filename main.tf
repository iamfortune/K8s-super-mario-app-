data "aws_caller_identity" "current" {}

module "networking" {
  source         = "./modules/networking"
  vpc_cidr_block = var.vpc_cidr_block
  azs            = var.azs
  cluster_name   = var.cluster_name
}

module "iam" {
  source = "./modules/iam"
}


module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  subnets_id = concat(
    module.networking.private_subnet_id, module.networking.public_subnet_id
  )
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_group_name  = var.node_group_name
  eks_node_role_arn    = module.iam.eks_node_role_arn
  node_instance_types  = var.node_instance_types
  node_security_group_id = module.security.node_security_group_id
  private_subnets_id   = module.networking.private_subnet_id
  iam_role_arn         = coalesce(var.cluster_admin_principal_arn, data.aws_caller_identity.current.arn)
  depends_on           = [module.iam, module.security]
}



module "security" {
  source       = "./modules/security"
  vpc_id       = module.networking.vpc_id
  cluster_name = var.cluster_name
}
