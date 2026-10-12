output "postgres_instance_id" {
  description = "PostgreSQL EC2 instance ID"
  value       = aws_instance.postgres.id
}

output "postgres_private_ip" {
  description = "Private IP address of PostgreSQL server"
  value       = aws_instance.postgres.private_ip
}

output "postgres_security_group_id" {
  description = "PostgreSQL security group ID"
  value       = aws_security_group.postgres.id
}

output "postgres_ami_id" {
  description = "Ubuntu AMI used for PostgreSQL"
  value       = data.aws_ami.ubuntu.id
}


output "sre_monitoring_instance_id" {
  description = "SRE monitoring EC2 instance ID"
  value       = aws_instance.sre_monitoring.id
}

output "sre_monitoring_private_ip" {
  description = "Private IP address of SRE monitoring EC2"
  value       = aws_instance.sre_monitoring.private_ip
}

output "sre_monitoring_security_group_id" {
  description = "Security group ID for SRE monitoring EC2"
  value       = aws_security_group.sre.id
}
