provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "new_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.new_vpc.id
}

resource "aws_subnet" "ans_sub" {
  vpc_id = aws_vpc.new_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "ans_sub"
  }
}

resource "aws_route_table" "ans_rt" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public_RT"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id = aws_subnet.ans_sub.id
  route_table_id = aws_route_table.ans_rt.id
}

resource "aws_security_group" "ans_sg" {
  name = "ans_ssh"
  vpc_id = aws_vpc.new_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from VPC"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ans-sg"
  }

}


resource "aws_instance" "ansible_server" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ans_sub.id
  vpc_security_group_ids = [ aws_security_group.ans_sg.id ]
  key_name = var.key-name
  associate_public_ip_address = true
  
  user_data = <<-EOF
  #!/bin/bash -ex

  sudo apt update
  sudo apt install software-properties-common -y
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible -y

  EOF

  tags = {
    Name = "ansible_server"
  }
}

resource "aws_instance" "target_server" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ans_sub.id
  vpc_security_group_ids = [ aws_security_group.ans_sg.id ]
  key_name = var.key-name
  associate_public_ip_address = true
  tags = {
    Name = "target_server"
  }
}