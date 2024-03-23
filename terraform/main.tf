provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app" {
  count         = var.instance_count
  ami           = "ami-0c101f26f147fa7fd" 
  instance_type = "t2.micro"

  key_name               = aws_key_pair.deployer.key_name
  security_groups        = ["${aws_security_group.app_sg.name}"]

user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo docker pull oluay87/lendable_tech_test:latest
              sudo docker run -d --restart unless-stopped -p 80:80 oluay87/lendable_tech_test:latest
              EOF

  tags = {
    Name = "AppServer ${count.index + 1}"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${var.public_key_path}")
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow web traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
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
