resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # Replace this with the ID of the NAT gateway created earlier
     gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "private" {
  count           = length(var.private_subnet_cidr_blocks)
  subnet_id       = aws_subnet.private[count.index].id
  route_table_id  = aws_route_table.private.id
}