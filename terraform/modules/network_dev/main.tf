#create development vpc
resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "development-vpc"
    Project = var.project_tag
  }
}

# First Public Subnet for NAT Gateway (in AZ1)
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.public_subnet_cidr_1
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name    = "dev-public-subnet-1"
    Project = var.project_tag
  }
}

# Second Public Subnet (in AZ2)
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = var.public_subnet_cidr_2
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name    = "dev-public-subnet-2"
    Project = var.project_tag
  }
}

# Private Subnet for Jenkins and GitLab
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.instaces_availability_zone
  tags = {
    Name    = "dev-private-subnet"
    Project = var.project_tag
  }
}

# Internet Gateway for the public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name    = "dev-IGW"
    Project = var.project_tag
  }
}

# Route table for the public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = "Public-RT"
    Project = var.project_tag
  }
}

# Associate Route Table with Public Subnet 1
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate Route Table with Public Subnet 2
resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway in Public Subnet 1
resource "aws_eip" "nat_eip" {
  tags = {
    Name    = "NAT-GW-Public-IP"
    Project = var.project_tag
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name    = "NAT-GW"
    Project = var.project_tag
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name    = "Private-RT"
    Project = var.project_tag
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# SSM Endpoint
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id       = aws_vpc.dev_vpc.id
  service_name = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg_vpc_endpoints.id]
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private_subnet.id]
  tags = {
    Name = "Endpoint-ssm"
    Project = var.project_tag
  }

}

# EC2 Messages Endpoint
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  vpc_id       = aws_vpc.dev_vpc.id
  service_name = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg_vpc_endpoints.id]  
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.private_subnet.id]
  tags = {
    Name = "Endpoint-ec2messages"
    Project = var.project_tag
  }

}

# SSM Messages Endpoint
resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  vpc_id       = aws_vpc.dev_vpc.id
  service_name = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.sg_vpc_endpoints.id]
  private_dns_enabled = true
  subnet_ids           = [aws_subnet.private_subnet.id]
  tags = {
    Name = "SSM-messages"
    Project = var.project_tag
  }
}

#Security group for endpoints
resource "aws_security_group" "sg_vpc_endpoints" {
  name        = "vpc-endpoints-sg"
  description = "Security group for VPC endpoints allowing HTTPS traffic from private subnet only"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow HTTPS from private subnet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoints-sg"
    Project = var.project_tag
  }
}
