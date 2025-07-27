terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc01"
  }
}
#creat subnet
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "vijaysubnet-01"
  }
}
#creat internet gateway
resource "aws_internet_gateway" "igw01" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw01"
  }
}
#rout tables
resource "aws_route_table" "rt01" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "rt01"
  }
}
#rought for internet access
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.rt01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw01.id
}
#rought table association
resource "aws_route_table_association" "subnet01_rt" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt01.id
}
#security groups
resource "aws_security_group" "sg01" {
  name        = "sg01"
  description = "Allow ssh, HTTP"
  vpc_id      = aws_vpc.vpc.id

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg01"
  }
}
#ec2 instance 
resource "aws_instance" "app_server" {
  ami                       = var.ami_id
  instance_type             = var.instance_type
  subnet_id                 = aws_subnet.subnet.id
  key_name                  = var.key_name
  vpc_security_group_ids    = [aws_security_group.sg01.id]
  associate_public_ip_address = true
  iam_instance_profile      = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install openjdk-21-jdk maven git -y
              cd /home/ubuntu
              git clone ${var.repo_url} app
              cd app
              mvn clean package
              mkdir -p /app/logs
              nohup java -jar target/hellomvc-0.0.1-SNAPSHOT.jar > /app/logs/app.log 2>&1 &
              sudo shutdown -h +60
              EOF

  tags = {
    Name = "ZeroMileEC2-${var.environment}"
  }
  }

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "ssh_command" {
  value = "ssh -i path/to/vijay123key.pem ubuntu@${aws_instance.app_server.public_ip}"
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "upload-to-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "upload_policy" {
  name = "upload-only-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "s3:PutObject"
      ],
      Effect   = "Allow",
      Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "upload_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.upload_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "upload-role-profile"
  role = aws_iam_role.ec2_role.name
}
