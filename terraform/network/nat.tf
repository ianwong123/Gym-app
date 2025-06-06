# 1 EIP for Single NAT instance
resource "aws_eip" "nat" {
    count = 1
    domain = "vpc"

    tags = {
        Name = "${var.project_name}-nat-eip"
    }
}

#Temporary removal of EIP association
# Associate EIP with NAT instance
/*resource aws_eip_association "nat" {
    instance_id = aws_instance.nat[0].id
    allocation_id = aws_eip.nat[0].id
}*/


# Single NAT instance in eu-north-1a only (instead of NAT Gateway for free tier)
resource aws_instance "nat" {
    count = 1
    ami = var.nat_ami
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public["public_a"].id
    vpc_security_group_ids = [var.nat_security_group_id]
    source_dest_check = false

    tags = {
        Name = "${var.project_name}-nat-0"
    }
}

# Route table for private subnets to use NAT instance
# Maybe only for a APP private subnet who only needs internet?
resource "aws_route_table" "private" {
    #count = length(var.private_subnets)
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        network_interface_id = aws_instance.nat[0].primary_network_interface_id
    }
    tags = {
        Name = "${var.project_name}-private-route-table"
    }
}

# Associate route table for all private subnets
# Associate route table table with only the APP subnet
resource "aws_route_table_association" "private" {
    for_each = { for key, subnet in aws_subnet.private : key => subnet if key == "app_a" || key == "app_b"}
    subnet_id = each.value.id
    #route_table_id = aws_route_table.private[0].id
    route_table_id = aws_route_table.private.id
}
