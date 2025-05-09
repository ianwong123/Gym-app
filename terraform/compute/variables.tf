variable "project_name" {
  description = "Gym app"
  type = string
  default = "gym-app"
}

variable "ami_id" {
    description = "AMI ID for EC2 instances"
    type = string
    default = "ami-01f5d894355bd0f64"
}

variable "subnet_ids" {
    type = map(string)
}

variable "web_security_group_id" {
  description = "Security group ID for EC2 instanes in the web tier"
  type = string
}

variable "app_security_group_id" {
  description = "Security group Id for EC2 instances in the app tier"
  type = string
}
