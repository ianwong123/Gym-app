resource "aws_security_group" "nat" {
    name = "${var.project_name}-nat-sg"
    description = "Allow all outbound traffic and only inbound TLS traffic"
    vpc_id = var.vpc_id
    
    tags = {
        name = "${var.project_name}-nat-sg"
    }
}

resource "aws_security_group" "web" {
    name = "${var.project_name}-web-sg"
    description = "Web Tier Security Group"
    vpc_id = var.vpc_id

    tags = {
        name = "${var.project_name}-web-sg"
    }
}

resource "aws_security_group" "app" {
    name = "${var.project_name}-app-sg"
    description = "App Tier Security Group"
    vpc_id = var.vpc_id

    tags = {
        name = "${var.project_name}-app-sg"
    }
}

# Web Ingress Security Group Rules HTTP Ipv4
resource aws_vpc_security_group_ingress_rule "web_http_ipv4" {
    security_group_id = aws_security_group.web.id 
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 80
    from_port = 80 

    tags = {
        name = "${var.project_name}-web-http-sg"
    }
}

# Web Ingress Security Group Rules HTTPS Ipv4
resource aws_vpc_security_group_ingress_rule "web_https_ipv4" {
    security_group_id = aws_security_group.web.id 
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 443
    from_port = 443 

    tags = {
        name = "${var.project_name}-web-https-sg"
    }
}

# Web Egress Security Group Rules Ipv4
resource aws_vpc_security_group_egress_rule "web_to_app_ipv4" {
    security_group_id = aws_security_group.web.id 
    referenced_security_group_id = aws_security_group.app.id
    ip_protocol = "tcp"
    from_port = 3000
    to_port = 3000

    tags = {
        name = "${var.project_name}-web-egress-sg"
    }
}

# App Ingress Security Group Rules Ipv4
resource aws_vpc_security_group_ingress_rule "app_from_web_ipv4" {
    security_group_id = aws_security_group.app.id 
    referenced_security_group_id = aws_security_group.web.id
    ip_protocol = "tcp"
    from_port = 3000
    to_port = 3000

    tags = {
        name = "${var.project_name}-app-ingress-sg"
    }
}

/* To be added later once RDS is configured
resource "aws_vpc_security_group_egress_rule" "app_to_rds" {
  security_group_id             = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.rds.id
  ip_protocol                   = "tcp"
  from_port                     = 5432 # PostgreSQL
  to_port                       = 5432
}*/

# NAT Ingress Security Group Rules Ipv4
resource aws_vpc_security_group_ingress_rule "allow_tls_ipv4" {
    security_group_id = aws_security_group.nat.id 
    cidr_ipv4 = var.vpc_cidr
    ip_protocol = "tcp"
    to_port = 443
    from_port = 443

    tags = {
      name = "${var.project_name}-nat-sg"
    }
}

# NAT Egress Security Group Rules Ipv4
resource aws_vpc_security_group_egress_rule "allow_all_ipv4" {
    security_group_id = aws_security_group.nat.id
    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"

    tags = {
        name = "${var.project_name}-nat-sg"
    }
}
