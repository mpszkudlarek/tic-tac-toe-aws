provider "aws" {
  region = "us-east-1"  # Specifies the AWS region in which resources will be created
  profile = "default"    # Uses default profile as per AWS configuration
}

resource "aws_instance" "tictactoe_tf" {
  ami = "ami-04e5276ebb8451442" # ID of the Amazon Machine Image to use for the instance
  instance_type = "t2.small" # Specifies the instance type
  key_name = "key_flask_vue" # SSH key name for instance authentication
  associate_public_ip_address = true # Determines if a public IP should be assigned
  vpc_security_group_ids = [aws_security_group.security_group_tf.id] # Security group to attach

  tags = {
    Name = "Tic Tac Toe TF"
  }

  user_data = file("install-app.sh") # User data script to run on instance initialization
}

resource "aws_vpc" "vpc_tf" {
  cidr_block = "10.0.0.0/16" # Defines the IP address range for the VPC
  enable_dns_support = true # Enables DNS support within the VPC
  enable_dns_hostnames = true # Enables DNS hostname resolution within the VPC

  tags = {
    Name = "VPC TF"
  }
}

resource "aws_subnet" "subnet_tf" {
  vpc_id = aws_vpc.vpc_tf.id # Associates the subnet with the VPC
  cidr_block = "10.0.1.0/24" # Defines the subnets IP address range

  tags = {
    Name = "Subnet TF"
  }
}

resource "aws_internet_gateway" "gateway_tf" {
  vpc_id = aws_vpc.vpc_tf.id # Associates the internet gateway with the VPC

  tags = {
    Name = "Gateway TF"
  }
}

resource "aws_route_table" "route_table_tf" {
  vpc_id = aws_vpc.vpc_tf.id # Associates the route table with the VPC

  route {
    cidr_block = "0.0.0.0/0" # Directs all traffic
    gateway_id = aws_internet_gateway.gateway_tf.id # Routes traffic through the internet gateway
  }

  tags = {
    Name = "Route Table TF"
  }
}

resource "aws_route_table_association" "subnet_tf" {
  subnet_id = aws_subnet.subnet_tf.id # Associates the subnet with the route table
  route_table_id = aws_route_table.route_table_tf.id
}

resource "aws_security_group" "security_group_tf" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allows all outbound traffic
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"] # Allows inbound SSH access
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    description = "Backend"
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic on port 3000 for backend access
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "Frontend"
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic on port 8080 for frontend access
  }
}
