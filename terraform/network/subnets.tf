resource "aws_subnet" "public" {
    for_each = var.public_subnets
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.az

    tags = {
        Name = "${var.project_name}-public-${each.key}"
        Tier = "public"
    }
}

resource "aws_subnet" "private" {
    for_each = var.private_subnets
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.az

    tags = {
        Name = "${var.project_name}-private-${each.key}"
        Tier = "private"
    } 
}

resource "aws_subnet" "db" {
    for_each = var.db_subnets
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.az

    tags = {
        Name = "${var.project_name}-db-${each.key}"
        Tier = "db"
    }
}