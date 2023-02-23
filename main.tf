
#Creating an Instance
resource "aws_instance" "example_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name = "ec2"
  vpc_security_group_ids = ["${aws_security_group.example_sg.id}"]
  subnet_id = "${aws_subnet.public[0].id}"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "EC2 Instance"
  }


}


resource "aws_security_group" "example_sg" {
  name_prefix = "example_sg"
   vpc_id = "${aws_vpc.my_vpc.id}"
ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "application"
  }
}
