terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "598990243446_Student"
}

resource "aws_security_group" "sg" {
  name        = "ansible_instance_sg"
  description = "Allow SSH, HTTP inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "kp" {
  key_name   = "id_rsa"
  public_key = file("/home/debian/.ssh/id_rsa.pub")
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "aws_linux" {
  ami             = "ami-065ab11fbd3d0323d"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.name]
  key_name        = aws_key_pair.kp.key_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "debian" {
  ami             = "ami-042e6fdb154c830c5"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.name]
  key_name        = aws_key_pair.kp.key_name
}

output "aws_linux_ip" {
  value = aws_instance.aws_linux.public_ip
}

output "debian_ip" {
  value = aws_instance.debian.public_ip
}

