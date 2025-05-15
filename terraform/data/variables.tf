variable "engine" {
  type = string
  description = "The database engine"
}

variable "engine_version" {
  type = string
  description = "The version of the database engine"
}

variable "instance_type" {
  type = string
  description = "Instance class for the db"
}

variable "db_name" {
  type = string
  description = "Name of the initial database"
}

variable "username" {
  type        = string
  description = "Username for db"
}

variable "password" {
  type        = string
  description = "Password for the db"
  sensitive   = true
}

variable "project_name" {
  description = "Gym app"
  type = string
  default = "gym-app"
}

variable "rds_security_group_id" {
  description = "Security group ID for bastion host"
  type = string
}

variable "subnet_ids" {
    description = "Subnet IDs"
    type = map(string)
}