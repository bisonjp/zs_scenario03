provider "aws" {
  region = var.aws_region
}

# VPCの作成
resource "aws_vpc" "vpc" {
  cidr_block = var.aws_vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.aws_vpc_name,
    Tag = var.aws_vpc_name
  }
}

# パブリックサブネットの作成
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.aws_pub_subnet_cidr
  availability_zone = var.aws_az1_name
  tags = {
    Name = "${var.aws_vpc_name}-public-subnet"
    Tag = var.aws_vpc_name
  }
}

# パブリックサブネット用ルートテーブルの作成
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.aws_vpc_name}-public-route-table"
    Tag = var.aws_vpc_name
  }
}

# Zscalerリソース用プライベートサブネットの作成
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.aws_pri1_subnet_cidr
  availability_zone = var.aws_az1_name
  tags = {
    Name = "${var.aws_vpc_name}-private-subnet1"
    Tag = var.aws_vpc_name
  }
}

# CC送信元用プライベートサブネットの作成
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.aws_pri2_subnet_cidr
  availability_zone = var.aws_az1_name
  tags = {
    Name = "${var.aws_vpc_name}-private-subnet2"
    Tag = var.aws_vpc_name
  }
}

# インターネットゲートウェイの作成
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.aws_vpc_name}-igw"
    Tag = var.aws_vpc_name
  }
}

# デフォルトルートをインターネットゲートウェイに設定
resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

#NATゲートウェイの作成
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "${var.aws_vpc_name}-nat-gateway"
    Tag = var.aws_vpc_name
  }
}

# Elastic IPの作成
resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "${var.aws_vpc_name}-eip"
    Tag = var.aws_vpc_name
  }
}

# パブリックサブネットにルートテーブルを紐づける
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Zscalerリソース用プライベートサブネットのルートテーブルの作成
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "${var.aws_vpc_name}-private_route_table"
    Tag = var.aws_vpc_name
  }
}

# CC送信元用プライベートサブネットのルートテーブルの作成
resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = module.cc_vm.service_eni_1[0]
  }
  tags = {
    Name = "${var.aws_vpc_name}-private_route_table2"
    Tag = var.aws_vpc_name
  }
}

# プライベートサブネットにルートテーブルを紐づける
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

# プライベートサブネットにルートテーブルを紐づける
resource "aws_route_table_association" "private_subnet_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table2.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.aws_vpc_name}-sg"
    Tag = var.aws_vpc_name
  }

}

#Windows Serverの作成
resource "aws_instance" "windows" {
  ami           = var.aws_win_ami
  instance_type = var.aws_win_instance_type
  subnet_id = aws_subnet.private_subnet2.id
  key_name = var.aws_instance_key
  tags = {
    Name = "${var.aws_vpc_name}-win"
    Tag = var.aws_vpc_name
  }
}
