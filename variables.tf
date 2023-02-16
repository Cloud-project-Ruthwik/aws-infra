# Define variables
variable "region" {
    type = string
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "VPC"
}

variable "profile" {
    default = "dev"  
}


data "aws_availability_zones" "available" {
  state = "available"
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# variable "public_subnet_count" {
#   type    = number
#   default = 3
# }


variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 3
 
}


variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "private_subnet_count" {
  type    = number
  default = 3
}

