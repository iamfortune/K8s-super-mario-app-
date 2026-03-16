
variable "aws_region" {
  description = "The region to use for the AWS provider"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "The availability zones for the VPC"
  type        = list(string)
}

# variable "public_subnet_cidr_block" {
#   description = "The CIDR blocks for the public subnets"
#   type        = string

# }

# variable "private_subnet_cidr_block" {
#   description = "The CIDR blocks for the private subnets"
#   type        = string
# }

variable "cluster_name" {
  description = "eks cluster name"
  type        = string
}
variable "node_group_name" {
  description = "node group name"
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types for the EKS managed node group"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "cluster_admin_principal_arn" {
  description = "IAM principal ARN to grant EKS cluster admin access. Set this explicitly if Terraform runs through an assumed role."
  type        = string
  default     = null
  nullable    = true
}
