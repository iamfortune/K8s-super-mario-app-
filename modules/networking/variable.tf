variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string

}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones to use for subnets"
}

variable "cluster_name" {
  description = "EKS cluster name used for subnet discovery tags"
  type        = string
}

variable "environment" {
  description = "Deployment environment label used in resource naming"
  type        = string
  default     = "dev"
}

# variable "public_subnet_cidr_block" {
#   description = "The CIDR blocks for the public subnets"
#   type        = string

# }

# variable "private_subnet_cidr_block" {
#   description = "The CIDR blocks for the private subnets"
#   type        = string
# }
