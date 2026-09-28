locals {
  # Workspace "develop" y "staging"
  env    = terraform.workspace
  prefix = "${var.app_name}-${terraform.workspace}"
}

resource "aws_key_pair" "ticomarket" {
  key_name   = "${local.prefix}-key"
  public_key = file(var.public_key_path)
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.prefix}-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_public_subnet
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.prefix}-public-${var.az}"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.prefix}-rtb-public"
  }
}

resource "aws_route_table_association" "rta_public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "app" {
  name   = "${local.prefix}-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH para Ansible"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "Puerto publico."
    from_port   = var.app_port
    to_port     = var.app_port
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
    Name = "${local.prefix}-sg"
  }
}

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = aws_key_pair.ticomarket.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  lifecycle {
    precondition {
      condition     = terraform.workspace != "default"
      error_message = "Elegir un ambiente antes del apply."
    }
  }

  tags = {
    Name    = "${local.prefix}"
    Project = "${var.app_name}"
    Env     = local.env
  }
}
