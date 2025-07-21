# terraform/vpc.tf
# VPC
resource "aws_vpc" "flask_app_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "flask-app-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "flask_app_igw" {
  vpc_id = aws_vpc.flask_app_vpc.id

  tags = {
    Name = "flask-app-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.flask_app_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "flask-app-public-subnet-${count.index + 1}"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.flask_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flask_app_igw.id
  }

  tags = {
    Name = "flask-app-public-rt"
  }
}

# Route Table Associations for Public Subnets
resource "aws_route_table_association" "public_rta" {
  count          = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}