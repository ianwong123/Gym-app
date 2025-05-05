variable "project_name" {
  description = "Gym app"
  type = string
  default = "gym-app"
}

variable "region" {
  description = "AWS region"
  type = string
  default = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type = string
  default = "10.1.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets configuration"
  type = map(object({
    cidr_block = string
    az         = string
  }))

  default = {
    public_a = {
      cidr_block = "10.1.0.0/24"
      az        = "eu-north-1a"
    }

    public_b = {
      cidr_block = "10.1.1.0/24"
      az        = "eu-north-1b"
    }
  }
}

variable "private_subnets" {
  description = "Private subnets configuration"
  type = map(object({
    cidr_block = string
    az         = string
  }))

  default = {
    web_a = {
      cidr_block = "10.1.16.0/20"
      az       = "eu-north-1a"
    }
    web_b = {
      cidr_block = "10.1.32.0/20"
      az       = "eu-north-1b"
    }
    app_a = {
      cidr_block = "10.1.48.0/20"
      az       = "eu-north-1a"
    }
    app_b = {
      cidr_block = "10.1.64.0/20"
      az       = "eu-north-1b"
    }
  }
}

variable "db_subnets" {
  description = "Database subnets configuration"
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    db_a = {
      cidr_block = "10.1.80.0/23"
      az        = "eu-north-1a"
    }
    db_b = {
      cidr_block = "10.1.82.0/23"
      az        = "eu-north-1b"
    }
  }
}

variable "nat_ami" {
  description = "AMI ID for NAT instance"
  type = string
  default = "ami-072517490bf2cf3a3"
}

variable "nat_security_group_id" {
    description = "The security group ID for the NAT instance"
    type        = string
}