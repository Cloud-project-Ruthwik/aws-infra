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

variable "certificate_arn"{
  default =  "arn:aws:acm:us-east-1:763590384604:certificate/5a47e8b2-e1ce-4c00-a3b0-125260c94711"
}

# dev = arn:aws:acm:us-east-1:882783971484:certificate/f9e14d49-a5db-48a7-a6b1-ef595185f587

