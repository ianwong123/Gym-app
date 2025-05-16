output "nat_security_group_id" {
  description = "The security group ID for NAT instance"
  value       = aws_security_group.nat.id
}

output "web_security_group_id" {
  description = "The security group ID for EC2 instances in the web tier"
  value       = aws_security_group.web.id
}

output "app_security_group_id" {
  description = "The seucrity group ID for EC2 instances in the app tier"
  value       = aws_security_group.app.id
}

output "bastion_security_group_id" {
  description = "The security group ID for bastion host"
  value       = aws_security_group.bastion.id
}

output "rds_security_group_id" {
  description = "The security group ID for RDS instances"
  value       = aws_security_group.rds.id
}

output "endpoint_security_group_id" {
  description = "The security group ID for the endpoint"
  value       = aws_security_group.endpoint.id
}
