#
#
#
#
#
#

provider "aws" {
    region = "us-east-2"
}
/**/

variable "key_name" {}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = var.key_name
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem"
  }
}

resource "aws_instance" "back-ub" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webserver-ub.id]
    key_name = aws_key_pair.kp.key_name
    provisioner "local-exec" {
    command = "echo ${aws_instance.back-ub.public_ip} >> ip.txt"
    }
}

resource "aws_instance" "front-ub" {
    ami = "ami-0fb653ca2d3203ac1"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webserver-ub.id]
    key_name = aws_key_pair.kp.key_name
    provisioner "local-exec" {
    command = "echo ${aws_instance.front-ub.public_ip} >> ip.txt"
    }
}

resource "aws_security_group" "webserver-ub" {
  name        = "webserver-security-group"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
