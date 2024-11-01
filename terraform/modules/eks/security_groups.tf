resource "aws_security_group" "eks_control_plane_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  description = "EKS Control Plane Security Group"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    description = "Allow access to the Kubernetes API server"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.cluster_name}-control-plane-sg"
    Project = var.project_tag
  }
}

resource "aws_security_group_rule" "allow_node_to_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"  # All protocols
  security_group_id        = aws_security_group.eks_control_plane_sg.id
  source_security_group_id = aws_security_group.eks_node_group_sg.id  # Reference the node group SG
}

resource "aws_security_group" "eks_node_group_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  description = "EKS Node Group Security Group"

  # Allow inbound traffic on ports 80 and 443 for ALB (HTTP/HTTPS traffic)
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from ALB
#    description = "Allow HTTP traffic on port 80"
#  }

#  ingress {
#   from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from ALB
#    description = "Allow HTTPS traffic on port 443"
#  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.cluster_name}-node-group-sg"
    Project = var.project_tag
  }
}

resource "aws_security_group_rule" "allow_control_plane_to_node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"  # All protocols
  security_group_id        = aws_security_group.eks_node_group_sg.id
  source_security_group_id = aws_security_group.eks_control_plane_sg.id  # Reference the control plane SG
}
