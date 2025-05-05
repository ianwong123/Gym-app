output "nat_security_group_id" {
  description = "The Security group ID for NAT instance"
  value       = aws_security_group.nat.id
}

