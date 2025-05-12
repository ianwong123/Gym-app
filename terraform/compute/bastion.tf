resource "aws_instance" "bastion" {
    subnet_id = "${var.subnet_ids["public_az1"]}"
    instance_type = "t3.micro"
    ami = var.ami_id
    associate_public_ip_address = true
    vpc_security_group_ids = [var.bastion_security_group_id]
    key_name = aws_key_pair.bastion_key.key_name

    tags = {
        Name = "${var.project_name}-bastion"
        Tier = "public-a"
    }
}   

# Generate a SSH key pair for bastion host
resource "aws_key_pair" "bastion_key" {
    key_name = "${var.project_name}-bastion-key"
    public_key = tls_private_key.bastion_key.public_key_openssh
}

# Generate public and private key 
resource "tls_private_key" "bastion_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "local_file" "private_key" {
    content = tls_private_key.bastion_key.private_key_pem
    filename = "${path.module}/gym-app-bastion-key.pem"
}