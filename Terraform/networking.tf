########################################
# VPC and Networking Configuration
########################################
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "KeepersAppVPC"
  }
}

########################################
# Subnet Configuration
########################################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name   = "DB-subnet1"
    Access = "Private"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name   = "DB-subnet2"
    Access = "Private"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "InternetGateway1"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "RouteTable1"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRouteTable1"
  }

}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRouteTable2"
  }

}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}

########################################
# Security Group Configuration
########################################

resource "aws_security_group" "ec2" {
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

resource "aws_security_group" "db" {
  vpc_id      = aws_vpc.main.id
  name        = "db-security-group"
  description = "Security group for RDS database"

  tags = {
    Name    = "DBSecurityGroup"
    Purpose = "Database Access Control"
  }
}

resource "aws_vpc_security_group_egress_rule" "db" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.ec2.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  security_group_id            = aws_security_group.ec2.id
  referenced_security_group_id = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}
