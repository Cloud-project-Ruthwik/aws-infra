variable "region" {
  description = "The region to create the VPC in"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "The profile is the account where to deploy the infrastructure"
  type        = string
  default = "dev"
}

variable "vpc_cidr" {
  description = "The IP range for the VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "The availability zones to create subnets in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "The IP ranges for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The IP ranges for the private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "public_route_table_cidr" {
  type        = string
  description = "The CIDR block of the public route table"
  default     = "0.0.0.0/0"
}

variable "private_route_table_cidr" {
  type        = string
  description = "The CIDR block of the private route table"
  default     = "0.0.0.0/0"
}

variable "ami_id" {
  description = "ID of the AMI to use for the EC2 instance"
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be launched"
  type        = string
  default     = "aws_subnet.public_subnet.1.id"
}

variable "ec2_instance_count" {
  type    = number
  default = 1
}

variable "keyname" {
  default = "my-keypair"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "db_username" {

}
variable "db_password" {

}
variable "db_instance_count" {
  default = 1
}


variable "zone_id" {
  default = "Z08052673S2S1008ZWHEV"
}

variable "certificate_arn"{
  default =  "arn:aws:acm:us-east-1:763590384604:certificate/5a47e8b2-e1ce-4c00-a3b0-125260c94711"
}

# dev = arn:aws:acm:us-east-1:882783971484:certificate/f9e14d49-a5db-48a7-a6b1-ef595185f587