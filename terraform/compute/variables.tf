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
