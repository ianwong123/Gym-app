resource "aws_security_group" "nat" {
    name = "${var.project_name}-nat-sg"
    description = "Allow all outbound traffic and only inbound TLS traffic"
    vpc_id = var.vpc_id
    
    tags = {
        name = "${var.project_name}-nat-sg"
    }
}

resource aws_vpc_security_group_ingress_rule "allow_tls_ipv4" {
    security_group_id = aws_security_group.nat.id 
    cidr_ipv4 = var.vpc_cidr
    ip_protocol = "tcp"
    to_port = 443
    from_port = 443
}

resource aws_vpc_security_group_egress_rule "allow_all_ipv4" {
    security_group_id = aws_security_group.nat.id
    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"
}

resource aws_vpc_security_group_egress_rule "allow_all_ipv6" {
    security_group_id = aws_security_group.nat.id
    ip_protocol = -1
    cidr_ipv6 = "::/0"
}