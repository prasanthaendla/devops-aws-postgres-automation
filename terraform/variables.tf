variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "vpc_id" {
  description = "Existing VPC where Jenkins is running"
  type        = string
}

variable "subnet_id" {
  description = "Existing subnet where PostgreSQL EC2 will be created"
  type        = string
}

variable "jenkins_security_group_id" {
  description = "Security group attached to Jenkins EC2"
  type        = string
}

variable "instance_type" {
  description = "PostgreSQL EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "jenkins"
}