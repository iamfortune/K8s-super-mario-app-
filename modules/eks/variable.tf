variable "cluster_name" {
  type = string

}

variable "subnets_id" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "private_subnets_id" {
  description = "List of private subnet IDs"
  type        = list(string)
}
variable "eks_version" {
  description = "The version of eks_cluster"
  default     = "1.31"

}

variable "eks_cluster_role_arn" {
  description = "ARN of the eks clutser"
  type        = string
}

variable "eks_node_group_name" {
  description = "node group name"
  type        = string
}

variable "eks_node_role_arn" {
  description = "node role arn"
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group"
  type        = list(string)
}

variable "node_security_group_id" {
  description = "Security group ID to attach to worker nodes via launch template"
  type        = string
}

variable "iam_role_arn" {
  description = "The IAM Principal ARN which requires Authentication"
  type        = string
}
