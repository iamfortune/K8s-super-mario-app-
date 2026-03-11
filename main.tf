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
  private_subnets_id   = module.networking.private_subnet_id
  depends_on           = [module.iam]
}
