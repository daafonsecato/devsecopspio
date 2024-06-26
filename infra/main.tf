terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name    = "my-internet-gateway"
    project = "devsecops-pio"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }

  tags = {
    Name    = "my-route-table"
    project = "devsecops-pio"
  }
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    project = "devsecops-pio"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    project = "devsecops-pio"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow inbound SSH and HTTP traffic"
  vpc_id      = aws_vpc.my_vpc.id
  tags = {
    project = "devsecops-pio"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["152.203.60.64/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.my_ec2_instance.id
}

resource "aws_eip_association" "my_eip_association" {
  instance_id   = aws_instance.my_ec2_instance.id
  allocation_id = aws_eip.my_eip.id
}

# Gitlab Runner
resource "aws_instance" "my_ec2_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "my-key-pair"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = <<-EOF
#!/bin/bash
yum install amazon-linux-extras -y docker
yum install -y git
# Add your commands here
echo "User-data commands executed successfully."
        EOF

  tags = {
    project = "devsecops-pio"
    Name    = "my-devsecops-pio-instance"
  }
}

# Gitlab Client
resource "aws_instance" "my_ec2_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "my-key-pair"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = <<-EOF
#!/bin/bash
yum install amazon-linux-extras -y docker
yum install -y git
# Add your commands here
echo "User-data commands executed successfully."
        EOF

  tags = {
    project = "devsecops-pio"
    Name    = "my-devsecops-pio-instance"
  }
}

# Prod
resource "aws_instance" "my_ec2_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "my-key-pair"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = <<-EOF
#!/bin/bash
yum install amazon-linux-extras -y docker
yum install -y git
# Add your commands here
echo "User-data commands executed successfully."
        EOF

  tags = {
    project = "devsecops-pio"
    Name    = "my-devsecops-pio-instance"
  }
}

# DefectDojo
resource "aws_instance" "my_ec2_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = "my-key-pair"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = <<-EOF
#!/bin/bash
yum install amazon-linux-extras -y docker
yum install -y git
# Add your commands here
echo "User-data commands executed successfully."
        EOF

  tags = {
    project = "devsecops-pio"
    Name    = "my-devsecops-pio-instance"
  }
}

# DSO
resource "aws_instance" "my_ec2_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.medium"
  key_name               = "my-key-pair"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = <<-EOF
#!/bin/bash
yum install amazon-linux-extras -y docker
yum install -y git
# Add your commands here
echo "User-data commands executed successfully."
        EOF

  tags = {
    project = "devsecops-pio"
    Name    = "my-devsecops-pio-instance"
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/suretro.pub")
  tags = {
    project = "devsecops-pio"
  }
}

output "ssh_connect_command" {
  value      = "ssh -i ~/.ssh/suretro ec2-user@${aws_instance.my_ec2_instance.public_ip}"
  depends_on = [aws_instance.my_ec2_instance]
}
