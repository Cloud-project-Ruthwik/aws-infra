resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "key.pem"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = var.keyname
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_security_group" "application" {
  name        = "application"
  description = "application security group"
  vpc_id     = var.vpc_id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "application port"
    from_port        = var.application_port
    to_port          = var.application_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Psql"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "application"
  }
}

# resource "aws_iam_instance_profile" "Webapp_ec2" {
#   name = "Webapp_ec2"
#   role = var.iam_role_name
# }

resource "aws_instance" "Webapp_ec2" {

  count                       = var.ec2_instance_count
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = var.public_subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.application.id]
  associate_public_ip_address = "true"
  disable_api_termination = false

user_data = <<EOF

 #!/bin/bash
 # Install Node.js and PM2
  curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
  sudo yum install -y nodejs
  sudo npm install -g pm2

# Change to app directory
cd /home/ec2-user

# Install dependencies and build the app
sudo npm install
sudo npm run build

# Set environment variables
cat <<EOT >> /home/ec2-user/.env
DB_HOST=${element(split(":", var.database_endpoint), 0)}
DB_USER=${var.database_username}
DB_PASSWORD=${var.database_password}
DB_DB=csye6225
AWS_BUCKET_NAME=${var.s3_bucket_name}
EOT
source /home/ec2-user/.env
# Start the app with PM2
pm2 restart /home/ec2-user/server.js
pm2 save

EOF

iam_instance_profile = aws_iam_instance_profile.Webapp_ec2.id

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.ec2_key.private_key_pem
    host        = aws_instance.ec2_instance.public_ip
  }

  tags = {
    Name = "Webapp_ec2"
  }

}



  resource "aws_route53_record" "Webapp_ec2" {
  count   = var.ec2_instance_count
  zone_id = var.zone_id
  name    = ""
  type    = "A"
  ttl     = 60
  records = [aws_instance.Webapp_ec2[count.index].public_ip]
}

