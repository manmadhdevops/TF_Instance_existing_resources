terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources to reference existing resources
data "aws_vpc" "selected" {
  id = var.existing_vpc_id
}

data "aws_subnet" "selected" {
  id = var.existing_subnet_id
}

# Create IAM instance profile (optional)
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_role" "instance_role" {
  name = "${var.instance_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# EC2 instance resource
resource "aws_instance" "My_Instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.existing_subnet_id
  vpc_security_group_ids = var.existing_security_group_ids
  
  # Network configuration
  associate_public_ip_address = var.enable_public_ip
  source_dest_check          = true
  
  # Instance metadata
  disable_api_termination = false
  iam_instance_profile    = aws_iam_instance_profile.instance_profile.name
  
  # Root volume configuration
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
    
    tags = {
      Name = "${var.instance_name}-root-volume"
    }
  }
  
  # User data (optional bootstrap script)
  user_data = <<-EOF
              #!/bin/bash
              echo "Instance ${var.instance_name} is starting up!" > /tmp/startup.log
              yum update -y
              EOF
  
  # Tags
  tags = merge(
    var.tags,
    {
      Name        = var.instance_name
      Environment = "Production"
      ManagedBy   = "Terraform"
    }
  )
  
  # Lifecycle settings
  lifecycle {
    create_before_destroy = false
    ignore_changes = [
      # Ignore changes to AMI as rolling updates are handled differently
      ami,
      # Ignore changes to user_data as updates require instance replacement
      user_data,
    ]
  }
}

# Elastic IP association (optional)
resource "aws_eip" "instance_eip" {
  count = var.enable_public_ip ? 1 : 0
  domain = "vpc"
  
  tags = {
    Name = "${var.instance_name}-eip"
  }
  
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_eip_association" "eip_assoc" {
  count         = var.enable_public_ip ? 1 : 0
  instance_id   = aws_instance.My_Instance.id
  allocation_id = aws_eip.instance_eip[0].id
}