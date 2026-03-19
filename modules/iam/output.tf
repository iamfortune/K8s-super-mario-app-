output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role — passed to aws_eks_cluster"
  value       = aws_iam_role.mario_eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "ARN of the EKS node group IAM role — passed to aws_eks_node_group"
  value       = aws_iam_role.mario_eks_node_role.arn
}

output "eks_cluster_role_name" {
  description = "Name of Eks cluster"
  value       = aws_iam_role.mario_eks_cluster_role.name
}

output "eks_node_role_name" {
  description = "Name of Eks node group role"
  value       = aws_iam_role.mario_eks_node_role.name
}

output "eks_cluster_policy_attachment" {
  value = aws_iam_role_policy_attachment.mario_eks_cluster_policy
}