provider "aws" {
  region = "us-east-1"  # Specifies the AWS region in which resources will be created
  profile = "default"    # Uses default profile as per AWS configuration, it takes credentials from ~/.aws/credentials
}

resource "aws_instance" "tictactoe_tf" {
  ami = "ami-04e5276ebb8451442" # ID of the Amazon Machine Image to use for the instance, ami-04e5276ebb8451442 is the Amazon Linux 2 AMI
  instance_type = "t2.small" # Specifies the instance type, t2.small is a general-purpose instance type
  key_name = "key_flask_vue" # SSH key name for instance authentication
  associate_public_ip_address = true # Determines if a public IP should be assigned
  vpc_security_group_ids = [aws_security_group.security_group_tf.id] # Security group to attach

  tags = {
    Name = "Tic Tac Toe TF" # Name tag for the instance
  }

  user_data = file("install-app.sh") # User data script to run on instance initialization
}

resource "aws_vpc" "vpc_tf" {
  cidr_block = "10.0.0.0/16" # Defines the IP address range for the VPC, in CIDR notation, so it can hold 65,536 IP addresses from 10.0.0.0 to 10.0.255.555
  enable_dns_support = true # Enables DNS support within the VPC, so instances can resolve domain names
  enable_dns_hostnames = true # Enables DNS hostname resolution within the VPC, so instances can have DNS hostnames

  tags = {
    Name = "VPC TF" # Name tag for the VPC
  }
}

resource "aws_subnet" "subnet_tf" {
  vpc_id = aws_vpc.vpc_tf.id # Associates the subnet with the VPC, so it can use the VPC's IP address range
  cidr_block = "10.0.1.0/24" # Defines the subnets IP address range, in CIDR notation, so it can hold 256 IP addresses from 10.0.1.0 to 10.01.255

  tags = {
    Name = "Subnet TF" # Name tag for the subnet
  }
}

resource "aws_internet_gateway" "gateway_tf" {
  vpc_id = aws_vpc.vpc_tf.id # Associates the internet gateway with the VPC, so it can route traffic to and from the internet

  tags = {
    Name = "Gateway TF" # Name tag for the internet gateway
  }
}

resource "aws_route_table" "route_table_tf" {
  vpc_id = aws_vpc.vpc_tf.id # Associates the route table with the VPC, so it can route traffic within the VPC

  route {
    cidr_block = "0.0.0.0/0" # Directs all traffic
    gateway_id = aws_internet_gateway.gateway_tf.id # Routes traffic through the internet gateway
  }

  tags = {
    Name = "Route Table TF" # Name tag for the route table
  }
}

resource "aws_route_table_association" "subnet_tf" {
  subnet_id = aws_subnet.subnet_tf.id # Associates the subnet with the route table, so it can route traffic within the subnet
  route_table_id = aws_route_table.route_table_tf.id # Associates the route table with the subnet, so it can route traffic within the VPC
}

resource "aws_security_group" "security_group_tf" {
  egress {
    from_port = 0 # Specifies the start of the port range for the egress rule
    to_port = 0 # Specifies the end of the port range for the egress rule
    protocol = "-1" # Specifies the protocol for the egress rule, -1 indicates all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allows all outbound traffic
  }

  ingress {
    from_port = 22 # Specifies the start of the port range for the ingress rule
    to_port = 22 # Specifies the end of the port range for the ingress rule
    protocol = "tcp" # Specifies the protocol for the ingress rule
    description = "SSH" # Description of the ingress rule
    cidr_blocks = ["0.0.0.0/0"] # Allows inbound SSH access
  }

  ingress {
    from_port = 3000 # Specifies the start of the port range for the ingress rule
    to_port = 3000 # Specifies the end of the port range for the ingress rule
    protocol = "tcp" # Specifies the protocol for the ingress rule
    description = "Backend" # Description of the ingress rule
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic on port 3000 for backend access
  }

  ingress {
    from_port = 8080 # Specifies the start of the port range for the ingress rule
    to_port = 8080 # Specifies the end of the port range for the ingress rule
    protocol = "tcp" # Specifies the protocol for the ingress rule
    description = "Frontend" # Description of the ingress rule
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic on port 8080 for frontend access
  }
}
