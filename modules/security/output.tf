output "node_security_group_id" {
  description = "Security group ID for EKS worker nodes"
  value       = aws_security_group.mario_node_sg.id
}
