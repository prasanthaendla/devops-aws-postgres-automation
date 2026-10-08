terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "devops-aws-postgres-tfstate-418295691815"
    key          = "devops-aws-postgres/terraform.tfstate"
    region       = "ap-south-2"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Find the latest official Ubuntu 26.04 AMD64 image
data "aws_ami" "ubuntu" {
  most_recent = false
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-20260916"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# PostgreSQL security group
resource "aws_security_group" "postgres" {
  name        = "devops-postgres-sg"
  description = "Security group for PostgreSQL EC2 server"
  vpc_id      = var.vpc_id

  # SSH only from Jenkins
  ingress {
    description     = "SSH from Jenkins"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.jenkins_security_group_id]
  }

  # PostgreSQL only from Jenkins
  ingress {
    description     = "PostgreSQL from Jenkins"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.jenkins_security_group_id]
  }

  # Outbound access for package installation and updates
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-postgres-sg"
  }
}

# PostgreSQL EC2 instance
resource "aws_instance" "postgres" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.postgres.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  tags = {
    Name = "devops-postgres-server"
    Role = "postgresql"
  }
}