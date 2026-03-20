# Node security group

resource "aws_security_group" "mario_node_sg" {
  name        = "${var.cluster_name}-node-sg"
  description = "security group for mario EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-node-sg"
    # Required tag so EKS knows this SG belongs to the cluster
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_vpc_security_group_ingress_rule" "node_self" {
  security_group_id            = aws_security_group.mario_node_sg.id
  referenced_security_group_id = aws_security_group.mario_node_sg.id
  description                  = "Node to node all traffic"
  ip_protocol                  = "-1"
}

# Internet → nodes: HTTP (for the Mario LoadBalancer)
resource "aws_vpc_security_group_ingress_rule" "internet_to_node_http" {
  security_group_id = aws_security_group.mario_node_sg.id
  description       = "Allow HTTP from internet to LoadBalancer"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}


# Nodes → anywhere (pull images, call AWS APIs, reach control plane)
resource "aws_vpc_security_group_egress_rule" "node_egress_all" {
  security_group_id = aws_security_group.mario_node_sg.id
  description       = "Nodes: all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
