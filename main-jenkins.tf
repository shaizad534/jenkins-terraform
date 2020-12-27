# Create key using awscli 
# aws ec2 create-key-pair --key-name jenkins --query 'KeyMaterial' --output text >jenkins.pem
# 

provider "aws" {
  region = var.region
}

# EC2 resource

resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instancetype
  key_name               = "jenkins"
  subnet_id              = var.subnetid
  associate_public_ip_address = true
  iam_instance_profile = "ec2-full-access-role"
  vpc_security_group_ids = [aws_security_group.jenkins.id]

  user_data = file("user-data.sh")
  tags = {
    Name = var.AppName
    Env  = var.Env
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Adding Security Group for our Instance :
resource "aws_security_group" "jenkins" {
  name        = "jenkins-sg"
  description = "Jenkins Security Group"
  vpc_id      = var.vpcid
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.HostIp]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.HostIp]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.PvtIp]
  }

ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

