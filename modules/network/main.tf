resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.pj_name}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.pj_name}-igw"
  }
}

# パブリックサブネット
resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.pj_name}-public-1a-subnet"
  }
}

# パブリックサブネット用RT
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.pj_name}-public-rt"
  }
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

# プライベートサブネット（1a)
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_1a_subnet_cidr
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.pj_name}-private-1a-subnet"
  }
}

# プライベートサブネット(1c)
resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_1c_subnet_cidr
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.pj_name}-private-1c-subnet"
  }
}

# プライベートサブネット用RT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.pj_name}-private-rt"
  }
}
resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private.id
}
