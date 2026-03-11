resource "aws_eks_cluster" "mario_cluster" {
  name = var.cluster_name

  access_config {
    authentication_mode = "API"
  }

  role_arn = var.eks_cluster_role_arn
  version  = var.eks_version
  vpc_config {
    subnet_ids = var.subnets_id
  }

}

resource "aws_eks_node_group" "mario_node" {
  cluster_name    = aws_eks_cluster.mario_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnets_id


  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }


}