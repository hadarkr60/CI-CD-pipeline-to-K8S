resource "aws_instance" "jenkins_agent" {
  ami                         = var.agent_ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  security_groups             = [aws_security_group.jenkins_agent_sg.id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = false
  private_ip                  = var.jenkins_agent_private_ip
  availability_zone           = var.instances_availability_zone
  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = "jenkins-agent"
    Project = "var.project_tag"
  }
  # User data to install Docker and run Jenkins in a container on Ubuntu
  user_data = <<-EOF
    #!/bin/bash
    sudo snap restart amazon-ssm-agent
   EOF
}


