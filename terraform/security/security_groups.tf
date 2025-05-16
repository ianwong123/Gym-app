data "http" "machine_ip" {
    url = "https://api64.ipify.org"

}

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

resource "aws_security_group" "bastion" {
    name = "${var.project_name}-bastion-sg"
    description = "Bastion Security Group"
    vpc_id = var.vpc_id

    tags = {
        name = "${var.project_name}-bastion-sg"
    }
}

resource "aws_security_group" "rds" {
    name = "${var.project_name}-rds-sg"
    description = "RDS Security Group"
    vpc_id = var.vpc_id

    tags = {
        name = "${var.project_name}-rds-sg"
    }
}

resource "aws_security_group" "endpoint" {
    name = "${var.project_name}-endpoint-sg"
    description = "Endpoint Security Group"
    vpc_id = var.vpc_id

    tags = {
        name = "${var.project_name}-endpoint-sg"
    }
}


# Web Ingress Security Group Rules HTTP Ipv4
resource aws_vpc_security_group_ingress_rule "web_http" {
    security_group_id = aws_security_group.web.id 
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 80
    from_port = 80 
    description = "Allow HTTP traffic from all IPs to Web SG"

    tags = {
        name = "${var.project_name}-web-http-sg"
    }
}

# Web Ingress Security Group Rules HTTPS Ipv4
resource aws_vpc_security_group_ingress_rule "web_https" {
    security_group_id = aws_security_group.web.id 
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    to_port = 443
    from_port = 443 

    tags = {
        name = "${var.project_name}-web-https-sg"
    }
}

# Web Ingress Security Group Rules Bastion Ipv4
resource aws_vpc_security_group_ingress_rule "bastion_web" {
    security_group_id = aws_security_group.web.id 
    referenced_security_group_id = aws_security_group.bastion.id
    ip_protocol = "tcp"
    to_port = 22
    from_port = 22 

    tags = {
        name = "${var.project_name}-bastion-web-sg"
    }
}

# Web Ingress Security Group Rules ICMP in 
resource "aws_vpc_security_group_ingress_rule" "web_icmp_in" {
  security_group_id = aws_security_group.web.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port   = -1
  to_port     = -1
  ip_protocol = "icmp"
  description = "Allow ICMP from Bastion to Web SG"

    tags = {
          name = "${var.project_name}-bastion-web-ICMP-sg"
     }
}

# Web Egress Security Group Rules Ipv4
resource aws_vpc_security_group_egress_rule "web_to_outbound" {
    security_group_id = aws_security_group.web.id 
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    description = "Allow outbound HTTPS traffic from Web SG to internet"
    cidr_ipv4 = "0.0.0.0/0"

    tags = {
        name = "${var.project_name}-web-egress-sg"
    }
}

# Web Egress Security Group Rules Ipv4
resource aws_vpc_security_group_egress_rule "web_to_app" {
    security_group_id = aws_security_group.web.id 
    referenced_security_group_id = aws_security_group.app.id
    ip_protocol = "tcp"
    from_port = 3000
    to_port = 3000
    description = "Allow traffic from Web SG to App SG on port 3000"

    tags = {
        name = "${var.project_name}-web-egress-sg"
    }
}

# App Ingress Security Group Rules Ipv4
resource aws_vpc_security_group_ingress_rule "app_from_web" {
    security_group_id = aws_security_group.app.id 
    referenced_security_group_id = aws_security_group.web.id
    ip_protocol = "tcp"
    from_port = 3000
    to_port = 3000
    description = "Allow traffic from Web SG to App SG on port 3000"

    tags = {
        name = "${var.project_name}-app-ingress-sg"
    }
}

# App Ingress Security Group Rules Bastion Ipv4
resource aws_vpc_security_group_ingress_rule "bastion_app" {
    security_group_id = aws_security_group.app.id 
    referenced_security_group_id = aws_security_group.bastion.id
    ip_protocol = "tcp"
    to_port = 22
    from_port = 22 
    description = "Allow SSH from Bastion to App SG"

    tags = {
        name = "${var.project_name}-bastion-app-sg"
    }
}

# Allow ICMP from Bastion SG to App
resource "aws_vpc_security_group_ingress_rule" "bastion_to_app_ping" {
  security_group_id = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port   = -1
  to_port     = -1
  ip_protocol = "icmp"

   tags = {
        name = "${var.project_name}-bastion-app-ICMP-sg"
    }
}


# Allow Egress Security Group Rules for App to RDS
resource "aws_vpc_security_group_egress_rule" "app_to_rds" {
  security_group_id             = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.rds.id
  ip_protocol                   = "tcp"
  from_port                     = 3306 
  to_port                       = 3306
}

# Allow Ingress Security from App to RDS
resource "aws_vpc_security_group_ingress_rule" "rds_from_app" {
  security_group_id = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.app.id
  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
  description = "MySQL access from App SG"

   tags = {
        name = "${var.project_name}-RDS-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "rds_bastion" {
    security_group_id = aws_security_group.rds.id
    referenced_security_group_id = aws_security_group.bastion.id
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    description = "Allow SSH from Bastion to RDS SG"

    tags = {
        name = "${var.project_name}-rds-ingress-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "rds_ICMP_in" {
    security_group_id = aws_security_group.rds.id
    referenced_security_group_id = aws_security_group.bastion.id
    ip_protocol = "icmp"
    from_port = -1
    to_port = -1
    description = "Allow ICMP from Bastion to RDS SG"
    
    tags = {
        name = "${var.project_name}-rds-ingress-sg"
    }
}

resource "aws_vpc_security_group_egress_rule" "rds_outbound" {
    security_group_id = aws_security_group.rds.id
    ip_protocol = "tcp"
    from_port = 3306
    to_port = 3306
    cidr_ipv4 = "0.0.0.0/0"

}


# Bastion Ingress Security Group Rules SSH from Client 
# Allow 0.0.0.0/0 for now for testing purposes until a solution to 
# the issue of using dynamically obtained local IP is found  
resource aws_vpc_security_group_ingress_rule "bastion_ssh" {
    security_group_id = aws_security_group.bastion.id
    #cidr_ipv4 = "${data.http.machine_ip.response_body}/32"
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    
    tags = {
        name = "${var.project_name}-bastion-ingress-sg"
    }
}

# Bastion Internet Access
resource aws_vpc_security_group_egress_rule "bastion_internet" {
    security_group_id = aws_security_group.bastion.id
    ip_protocol = "tcp"  
    from_port = 443
    to_port = 443
    cidr_ipv4 = "0.0.0.0/0"
    description = "Allow HTTPS outbound traffic to internet"
}

# Bastion Web Egress Security Group Rules SSH
resource aws_vpc_security_group_egress_rule "bastion_to_web" {
    security_group_id = aws_security_group.bastion.id
    referenced_security_group_id = aws_security_group.web.id
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    description = "Allow SSH to Web SG"

    tags = {
        name = "${var.project_name}-bastion-web-egress-sg"
    }
}


# Bastion App Egress Security Group Rules SSH
resource aws_vpc_security_group_egress_rule "bastion_to_app" {
    security_group_id = aws_security_group.bastion.id
    referenced_security_group_id = aws_security_group.app.id
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    description = "Allow SSH to App SG"

    tags = {
        name = "${var.project_name}-bastion-app-egress-sg"
    }
}

# Bastion Web Egress Security Group Rules ICMP
resource aws_vpc_security_group_egress_rule "bastion_icmp_out" {
    security_group_id = aws_security_group.bastion.id
    ip_protocol = "icmp"
    from_port = -1
    to_port = -1
    cidr_ipv4 = var.vpc_cidr
    description = "Allow ICMP from Bastion to all SG"

    tags = {
        name = "${var.project_name}-bastion-web-egress-sg"
    }
}

# NAT Ingress Security Group Rules 
resource aws_vpc_security_group_ingress_rule "allow_tls" {
    security_group_id = aws_security_group.nat.id 
    cidr_ipv4 = var.vpc_cidr
    ip_protocol = "tcp"
    to_port = 443
    from_port = 443
    description = "Allow TLS from VPC CIDR to NAT SG"

    tags = {
      name = "${var.project_name}-nat-sg"
    }
}



# NAT Egress Security Group Rules Ipv4
resource aws_vpc_security_group_egress_rule "allow_all" {
    security_group_id = aws_security_group.nat.id
    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"
    description = "Allow all outbound traffic from NAT SG"

    tags = {
        name = "${var.project_name}-nat-sg"
    }
}

# Security Group for Ingress Endpoint
resource "aws_vpc_security_group_ingress_rule" "endpoint_ingress" {
    security_group_id = aws_security_group.endpoint.id
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_ipv4 = var.vpc_cidr
    description = "Allow HTTPS inbound traffic to internet"

    tags = {
        name = "${var.project_name}-endpoint-sg"
    }
}

# Security Group for Egress Endpoint
resource "aws_vpc_security_group_egress_rule" "endpoint_egress" {
    security_group_id = aws_security_group.endpoint.id
    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"
    description = "Allow  outbound traffic to internet"

    tags = {
        name = "${var.project_name}-endpoint-sg"
    }
}