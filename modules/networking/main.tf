resource "aws_vpc" "mario_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mario-vpc-${var.environment}"
  }
}
# For Load Balancer & NAT Gateway
resource "aws_subnet" "mario_public_subnet" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.mario_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = var.azs[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name                                        = "mario-public-subnet-${var.environment}-${count.index + 1}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Private Subnets For EKS worker nodes
resource "aws_subnet" "mario_private_subnet" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.mario_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index + length(var.azs))
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name                                        = "mario-private-subnet-${var.environment}-${count.index + 1}"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

}

# Internet access for public subnet
resource "aws_internet_gateway" "mario_gw" {
  vpc_id = aws_vpc.mario_vpc.id

  tags = {
    Name = "mario-igw-${var.environment}"
  }

}

# Static IP for NAT Gateway
resource "aws_eip" "mario_nat_eip" {
  domain = "vpc"

  tags = {
    Name = "mario-nat-eip-${var.environment}"
  }

}

# Outbound internet for private nodes
resource "aws_nat_gateway" "mario_nat_gateway" {
  allocation_id = aws_eip.mario_nat_eip.id
  subnet_id     = aws_subnet.mario_public_subnet[0].id

  tags = {
    Name = "mario-nat-gw"
  }

  depends_on = [aws_internet_gateway.mario_gw]
}

# Traffic routing rules
resource "aws_route_table" "mario_public_route_table" {
  vpc_id = aws_vpc.mario_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mario_gw.id
  }


  tags = {
    Name = "mario-public-rt-${var.environment}"
  }
}

# Traffic routing rules
resource "aws_route_table" "mario_private_route_table" {
  vpc_id = aws_vpc.mario_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mario_nat_gateway.id
  }

  tags = {
    Name = "mario-private-rt-${var.environment}"
  }
}

resource "aws_route_table_association" "mario_public_rta" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.mario_public_subnet[count.index].id
  route_table_id = aws_route_table.mario_public_route_table.id
}

resource "aws_route_table_association" "mario_private_rta" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.mario_private_subnet[count.index].id
  route_table_id = aws_route_table.mario_private_route_table.id
}
