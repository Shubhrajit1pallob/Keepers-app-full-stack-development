data "aws_ami" "ubuntu" {

  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.this.id
  key_name = aws_key_pair.this.key_name
  vpc_security_group_ids = [ aws_security_group.this.id ]


  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "KeepersAppInstance"
  }
}

// The key pair resource is used to allow SSH access to the instance
resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = var.public_key
}

// The data source for the current AWS region
data "aws_region" "current" {}

// The Elastic IP resource is used to assign a static IP to the instance
resource "aws_eip" "this" {
  instance = aws_instance.this.id

  tags = {
    Name = "ElasticIP1"
  }
}