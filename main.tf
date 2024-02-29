provider "aws" {
  region = var.aws_region
}

data "aws_ami" "dev_ami" {
  most_recent = true
  filter {
    name   = "tag:Env"
    values = ["dev"]
  }

}


#Create security group with firewall rules
resource "aws_security_group" "Test_security_group" {
  name        = var.security_group
  description = "security group for Ec2 instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound from jenkis server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = var.security_group
    yor_trace = "7a3a1e74-fbb4-4609-9f9c-029129f7c953"
  }
}

# Create AWS ec2 instance
resource "aws_instance" "TestInstance" {
  ami             = data.aws_ami.dev_ami.id
  key_name        = var.key_name
  instance_type   = var.instance_type
  security_groups = [var.security_group]
  tags = {
    Name      = var.tag_name
    yor_trace = "e4bbb4c5-5c5e-4000-a10d-09631c2cb0d1"
  }
}

# Create Elastic IP address
resource "aws_eip" "TestInstance" {
  vpc      = true
  instance = aws_instance.TestInstance.id
  tags = {
    Name      = "my_elastic_ip"
    yor_trace = "bb6d2365-f8d4-4544-ad2c-0f4ab696f649"
  }
}
