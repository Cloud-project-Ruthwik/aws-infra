variable "public_subnet_ids" {
  description = "Public Subnet Id"
}


variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "application_port" {
  type    = number
  default = 3000
}

# variable "instance_id"{

# }

variable "zone_id"{
  default = "Z08052673S2S1008ZWHEV"
}
