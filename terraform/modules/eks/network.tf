resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "${var.cluster_name}-eks-vpc"
    Project = var.project_tag
  }
}

resource "aws_subnet" "private_subnet" {
  count               = 2
  vpc_id              = aws_vpc.eks_vpc.id
  cidr_block          = var.private_subnet_cidrs[count.index]
  availability_zone   = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.cluster_name}-private-subnet-${count.index}"
    Project = var.project_tag
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public_subnet" {
  count               = 2
  vpc_id              = aws_vpc.eks_vpc.id
  cidr_block          = var.public_subnet_cidrs[count.index]
  availability_zone   = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.cluster_name}-public-subnet-${count.index}"
    Project = var.project_tag
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name    = "${var.cluster_name}-igw"
    Project = var.project_tag
  }
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name    = "${var.cluster_name}-nat-eip"
    Project = var.project_tag
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id  # Place the NAT Gateway in a public subnet
  tags = {
    Name    = "${var.cluster_name}-nat-gateway"
    Project = var.project_tag
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = "${var.cluster_name}-public-route-table"
    Project = var.project_tag
  }
}

resource "aws_route_table_association" "public_route_assoc" {
  count           = 2
  subnet_id       = aws_subnet.public_subnet[count.index].id
  route_table_id  = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id  # Route private traffic through the NAT Gateway
  }
  tags = {
    Name    = "${var.cluster_name}-private-route-table"
    Project = var.project_tag
  }
}

resource "aws_route_table_association" "private_route_assoc" {
  count           = 2
  subnet_id       = aws_subnet.private_subnet[count.index].id
  route_table_id  = aws_route_table.private_route_table.id
}
