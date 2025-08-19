resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "KeepersAppVPC"
  }
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "InternetGateway1"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "RouteTable1"
  }
}

resource "aws_security_group" "this" {
  vpc_id = aws_vpc.main.id

  // Allow inbound SSH traffic
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all inbound traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
  }

  // Allow inbound HTTP traffic
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all inbound traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
  }
}
