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

resource "aws_iam_instance_profile" "Webapp_ec2" {
  name = "Webapp_ec2"
  role = var.iam_role_name
}

resource "aws_instance" "Webapp_ec2" {

  count                       = var.ec2_instance_count
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = var.public_subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.application.id]
  associate_public_ip_address = "true"
  disable_api_termination = false

user_data = <<-EOF
          #cloud-boothook
          #!/bin/bash
          sudo -u ec2-user touch /home/ec2-user/.env
          # Add the values
          sudo -u ec2-user echo "DB_USER=${var.database_username}" >> /home/ec2-user/.env
          sudo -u ec2-user echo "DB_PASSWORD=${var.database_password}" >> /home/ec2-user/.env
          sudo -u ec2-user echo "DB_HOST=${element(split(":", var.database_endpoint), 0)}" >> /home/ec2-user/.env
          sudo -u ec2-user echo "AWS_BUCKET_NAME=${var.s3_bucket_name}" >> /home/ec2-user/.env
          sudo -u ec2-user echo "DB_DB=csye6225" >> /home/ec2-user/.env
          sudo -u ec2-user echo "AWS_REGION=${var.region}" >> /home/ec2-user/.env

         
          # Start the app with PM2
pm2 restart /home/ec2-user/server.js
pm2 restart all --update-env
pm2 reload ecosystem.json --update-env
pm2 save


           EOF

iam_instance_profile = aws_iam_instance_profile.Webapp_ec2.id
  
  provisioner "remote-exec" {
    inline = [
      "pm2 startup",
      "sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.19.1/bin /home/ec2-user/.nvm/versions/node/v16.19.1/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user",
      # "sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.19.1/bin /home/ec2-user/.nvm/versions/node/v16.19.1/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user",
      "pm2 start server.js --env=.env",
      "pm2 save",
      "sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/home/ec2-user/config.json -s"
    ]
    connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.ec2_key.private_key_pem
    }
  }
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.ec2_key.private_key_pem
    host        = aws_instance.Webapp_ec2[count.index].public_ip
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
  ttl     = 120
  records = [aws_instance.Webapp_ec2[count.index].public_ip]
}