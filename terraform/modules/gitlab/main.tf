# modules/gitlab/main.tf

resource "aws_instance" "gitlab" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  security_groups             = [aws_security_group.gitlab_sg.id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = false
  private_ip                  = var.private-ip
  availability_zone           = var.instances_availability_zone
  root_block_device {
    volume_size = 12
  }

  tags = {
    Name = "gitlab-server"
    Project = var.project_tag
  }

  # User data to install GitLab
  user_data = <<-EOF
    #!/bin/bash
    sudo snap restart amazon-ssm-agent
  EOF
}

