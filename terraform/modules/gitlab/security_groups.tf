resource "aws_security_group" "gitlab_sg" {
  vpc_id = var.vpc_id

  # Allow inbound traffic on port 80 for GitLab's web interface
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr]  # Internal access (or adjust as needed)
    description = "Allow HTTP traffic on port 80 for GitLab from within the private subnet"
  }

  # Allow all outbound traffic for GitLab to access the internet via NAT
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
    description = "Allow all outbound traffic for GitLab"
  }

  tags = {
    Name = "gitlab-security-group"
    Project = "var.project_tag"
  }
}

resource "aws_security_group_rule" "allow_alb_security_group" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  security_group_id        = aws_security_group.gitlab_sg.id
  source_security_group_id = var.alb_security_group
}

