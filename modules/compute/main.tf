#-----compute/main.tf-----
#==========================
terraform {
  required_version = ">= 1.7.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.43.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
}

provider "aws" {
  region = var.region
}

#Get Linux AMI ID using SSM Parameter endpoint
#==============================================
data "aws_ssm_parameter" "webserver-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2
#======================================
resource "aws_key_pair" "aws-key" {
  key_name   = "docker"
  public_key = file(var.ssh_key_public)
}

#Create a Server
#=================
resource "aws_instance" "docker" {
  instance_type = "t2.micro"
  ami           = data.aws_ssm_parameter.webserver-ami.value

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name = "docker_tf"
  }
  key_name                    = aws_key_pair.aws-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group]
  subnet_id                   = var.subnets
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_key_private)
    host        = self.public_ip
  }
}
