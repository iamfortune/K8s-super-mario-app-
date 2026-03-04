
data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "mario_eks_cluster_role" {
  name               = "mario-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = {
    Name = "mario-eks-cluster-role-${var.environment}"
  }

}

resource "aws_iam_role_policy_attachment" "mario_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.mario_eks_cluster_role.name
}



# ─────────────────────────────────────────────
# EKS NODE GROUP ROLE
# ─────────────────────────────────────────────

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# ==========================================
# Attaching policy document to iam role
# ==========================================
resource "aws_iam_role" "mario_eks_node_role" {
  name               = "mario-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json
  tags = {
    Name = "mario-eks-node-role-${var.environment}"
  }
}

# ── Attachment 1: Core worker node permissions
resource "aws_iam_role_policy_attachment" "mario_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.mario_eks_node_role.name
}

# ── Attachment 2: Pod networking via AWS VPC CNI plugin
resource "aws_iam_role_policy_attachment" "mario_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.mario_eks_node_role.name
}

# ── Attachment 3: Pull container images from ECR (read-only)
resource "aws_iam_role_policy_attachment" "mario_ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.mario_eks_node_role.name
}