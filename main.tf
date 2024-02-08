
#Create security group with firewall rules
resource "aws_security_group" "Test_security_group" {
  name        = var.security_group
  description = "security group for Ec2 instance"

  tags= {
    Name = var.security_group
  }
}

# Create AWS ec2 instance
resource "aws_instance" "TestInstance" {
  ami           = data.aws_ami.dev_ami.id
  key_name = var.key_name
  instance_type = var.instance_type
  security_groups= [var.security_group]
  tags= {
    Name = var.tag_name
  }
}
