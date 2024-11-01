resource "aws_security_group" "jenkins_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_cidr] 
    description = "Allow Jenkins traffic from the private subnet (GitLab integration)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "jenkins-security-group"
    Project = "var.project_tag"
  }
}

resource "aws_security_group_rule" "allow_alb_security_group" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "TCP"  
  security_group_id        = aws_security_group.jenkins_sg.id
  source_security_group_id = var.alb_security_group
}

resource "aws_security_group" "jenkins_agent_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.jenkins_private_ip_cidr]
    description = "Allow master to access agent via ssh"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "jenkins-agent-security-group"
    Project = "var.project_tag"
  }
}
