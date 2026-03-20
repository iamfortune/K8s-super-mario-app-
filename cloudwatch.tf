resource "aws_cloudwatch_log_group" "mario_cluster" {
  name = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 14

  tags = {
    Name = "${var.cluster_name}-logs"
  }
}

resource "aws_iam_role_policy_attachment" "cluster_cloudwatch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = "mario-eks-cluster-role"
}