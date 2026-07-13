terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "sock-shop-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_vpc" "sock_shop" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "sock-shop-vpc"
  }
}

resource "aws_subnet" "sock_shop" {
  vpc_id            = aws_vpc.sock_shop.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "sock-shop-subnet"
  }
}

resource "aws_internet_gateway" "sock_shop" {
  vpc_id = aws_vpc.sock_shop.id

  tags = {
    Name = "sock-shop-igw"
  }
}

resource "aws_route_table" "sock_shop" {
  vpc_id = aws_vpc.sock_shop.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.sock_shop.id
  }

  tags = {
    Name = "sock-shop-rt"
  }
}

resource "aws_route_table_association" "sock_shop" {
  subnet_id      = aws_subnet.sock_shop.id
  route_table_id = aws_route_table.sock_shop.id
}

resource "aws_security_group" "k8s_node_sg" {
  name        = "sock-shop-k8s-sg"
  description = "Security group for Kubernetes node with restricted access"
  vpc_id      = aws_vpc.sock_shop.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
    description = "SSH access from allowed IPs"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access for application"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access for application"
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.sock_shop.cidr_block]
    description = "Kubernetes API access (VPC only)"
  }

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.k8s_node_sg.id]
    description     = "Allow internal cluster communication"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "sock-shop-k8s-sg"
  }
}

resource "aws_instance" "k8s_node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.sock_shop.id
  vpc_security_group_ids = [aws_security_group.k8s_node_sg.id]

  monitoring = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 50
    delete_on_termination = true
    encrypted             = true
  }

  user_data = base64encode(file("${path.module}/user_data.sh"))

  tags = {
    Name = "Sock-Shop-K8s-Node"
  }

  depends_on = [aws_internet_gateway.sock_shop]
}

resource "aws_eip" "k8s_node" {
  instance = aws_instance.k8s_node.id
  domain   = "vpc"

  tags = {
    Name = "sock-shop-eip"
  }

  depends_on = [aws_internet_gateway.sock_shop]
}
