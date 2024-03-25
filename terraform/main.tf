# Configure the AWS provider with the specified region where the resources will be deployed.
# This sets the foundation for all AWS resource deployments in the Terraform script.
provider "aws" {
  region = "us-east-1"
}

# Define an AWS EC2 instance resource. This block is responsible for creating
# EC2 instances according to the specified configurations like AMI, instance type, and count.
resource "aws_instance" "app" {
  count         = var.instance_count  # Determines how many instances to create based on the variable value.
  ami           = "ami-0c101f26f147fa7fd"  # Specifies which AMI to use for the instance, influencing OS and pre-installed packages.
  instance_type = "t2.micro"  # The type of instance to deploy, balancing cost and performance for the application needs.

  key_name      = aws_key_pair.deployer.key_name  # Associates an SSH key for secure access to the instances.
  security_groups = [aws_security_group.app_sg.name]  # Attaches a security group to define network access rules for the instance.

  # User data script to automate initial setup tasks on the instance like installing Docker,
  # pulling the latest Docker image, and running a Docker container from that image.
  user_data = <<-EOF
  #!/bin/bash
  sudo yum install docker -y
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  sudo docker pull oluay87/lendable_tech_test:latest
  sudo docker run -d --restart unless-stopped -p 80:80 oluay87/lendable_tech_test:latest
EOF

  # Tags the instance for easier identification and management within the AWS ecosystem.
  tags = {
    Name = "AppServer ${count.index + 1}"
  }
}

# Creates an SSH key pair resource for instance access. The public key is provided
# via a variable, allowing SSH access to the EC2 instances.
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)  # Reads the public key from the specified file path.
}

# Defines a security group to control network access to and from the EC2 instances.
# This is crucial for defining what traffic can reach the application and ensuring its security.
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow web traffic"

  # Ingress rule to allow HTTP traffic on port 80 from any source.
  # Essential for making the web server accessible from the internet.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule to allow SSH access on port 22 from any source.
  # This provides the capability to securely manage the instances.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic from the instances.
  # This ensures the instances can reach the internet, for example, to pull Docker images.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

