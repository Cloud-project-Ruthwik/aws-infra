# Create Public Subnets

resource "aws_subnet" "public" {
  count             = var.public_subnet_count
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)


  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
   tags = {
    "Name" = "Public Subnet"
  }
}
