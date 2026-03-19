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

resource "aws_eks_access_entry" "mario_cluster_access_entry" {
  cluster_name  = aws_eks_cluster.mario_cluster.name
  principal_arn = var.iam_role_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "mario_cluster_admin" {
  cluster_name  = aws_eks_cluster.mario_cluster.name
  principal_arn = var.iam_role_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_node_group" "mario_node" {
  cluster_name    = aws_eks_cluster.mario_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.eks_node_role_arn
  instance_types  = var.node_instance_types
  subnet_ids      = var.private_subnets_id



  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }


}
