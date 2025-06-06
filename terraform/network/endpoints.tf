# For SSM
resource "aws_vpc_endpoint" "ssm_app" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.private["app_a"].id, aws_subnet.private["app_b"].id] 
  private_dns_enabled = true
  security_group_ids = [var.endpoint_security_group_id]

  tags = {
    Name = "${var.project_name}-ssm-endpoint"
  }
}

# For SSM messages
resource "aws_vpc_endpoint" "ssmmessages_app" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.private["app_a"].id, aws_subnet.private["app_b"].id] 
  private_dns_enabled = true
  security_group_ids = [var.endpoint_security_group_id]

  tags = {
    Name = "${var.project_name}-ssm-endpoint"
  }
}

# For EC2 messages
resource "aws_vpc_endpoint" "ec2messages_app" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.private["app_a"].id, aws_subnet.private["app_b"].id] 
  private_dns_enabled = true
  security_group_ids = [var.endpoint_security_group_id]

  tags = {
    Name = "${var.project_name}-ssm-endpoint"
  }
}