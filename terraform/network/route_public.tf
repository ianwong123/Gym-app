resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.project_name}-public-route-table"
    }
}

resource "aws_route_table_association" "public" {
    for_each = var.public_subnets
    subnet_id = aws_subnet.public[each.key].id
    route_table_id = aws_route_table.public.id
}