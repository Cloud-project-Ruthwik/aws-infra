resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "Private Subnet"
  }
}