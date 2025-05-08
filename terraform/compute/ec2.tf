resource "aws_instance" "public_a" {
    ami = var.ami_id
    instance_type = "t3.micro"
    subnet_id = var.subnet_ids["public_az1"]

    tags = {
        Name = "${var.project_name}-public-a"
        Tier = "public"
    }
}

resource "aws_instance" "public_b" {
    ami = var.ami_id
    instance_type = "t3.micro"
    subnet_id = var.subnet_ids["public_az2"]

    tags = {
        Name = "${var.project_name}-public-b"
        Tier = "public"
    }
}

resource "aws_instance" "web_a" {
    ami = var.ami_id
    instance_type = "t3.micro"
    subnet_id = var.subnet_ids["web_az1"]

    tags = {
        Name = "${var.project_name}-web-a"
        Tier = "private-web"
    }
}

resource "aws_instance" "web_b" {
    ami = var.ami_id
    instance_type = "t3.micro"
    subnet_id = var.subnet_ids["web_az2"]

    tags = {
        Name = "${var.project_name}-web-b"
        Tier = "private-web"
    }
}

resource "aws_instance" "app_a" {
    ami = var.ami_id
    instance_type = "t3.micro"
    subnet_id = var.subnet_ids["app_az1"]

    tags = {
        Name = "${var.project_name}-app-a"
        Tier = "private-app"
    }
}

resource "aws_instance" "app_b" {
    ami = var.ami_id
    instance_type = "t3.micro"
    subnet_id = var.subnet_ids["app_az2"]

    tags = {
        Name = "${var.project_name}-app-b"
        Tier = "private-app"
    }
}

