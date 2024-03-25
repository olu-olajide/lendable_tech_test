# The AWS provider configuration specifies the AWS region where the resources will be deployed. 
# Choosing a region is crucial as it affects latency for your users and can also impact costs.
provider "aws" {
  region = "us-east-1"
}

# This resource block defines the EC2 instances that will host our Dockerized Nginx web server.
# 'count' allows us to create multiple instances based on the 'instance_count' variable, 
# enabling easy scaling of our deployment.
resource "aws_instance" "app" {
  count         = var.instance_count
  ami           = "ami-0c101f26f147fa7fd"  # Specifies the Amazon Machine Image (AMI) to use for the instances, which should have the necessary dependencies pre-installed.
  instance_type = "t2.micro"  # Defines the type of instance, balancing cost and compute capacity for our use case.

  key_name      = aws_key_pair.deployer.key_name  # Associates an SSH key for secure access to the instances.
  security_groups = ["${aws_security_group.app_sg.name}"]  # Attaches a security group to define allowable inbound and outbound traffic.

  # User data script to automate the setup process on instance launch, such as installing Docker, 
  # pulling the latest version of our Dockerized application, and running it.
  user_data = <<-EOF
  #!/bin/bash
  sudo yum install docker -y
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  sudo docker pull oluay87/lendable_tech_test:latest
  sudo docker run -d --restart unless-stopped -p 80:80 oluay87/lendable_tech_test:latest
EOF

  # Tags the instances for easier identification, especially useful when filtering resources within the AWS console.
  tags = {
    Name = "AppServer ${count.index + 1}"
  }
}

# This resource block creates an SSH key pair, enabling secure SSH access to the instances.
# The public key is specified through the 'public_key_path' variable.
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${var.public_key_path}")
}

# Defines a security group that controls the inbound and outbound traffic for our instances.
# Here, we allow inbound HTTP traffic on port 80 and SSH access on port 22, 
# and permit all outbound traffic, ensuring our web server is accessible from the internet
# and that the instances can reach external services if needed.
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow web traffic and SSH access"

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

# The 'instance_count' variable determines how many EC2 instances to deploy.
# This approach allows for easy adjustments based on load or budget considerations.
variable "instance_count" {
  description = "The number of instances to deploy."
  type        = number
  default     = 1
}

# The 'public_key_path' variable specifies the path to the SSH public key used for the 'aws_key_pair' resource.
variable "public_key_path" {
  description = "Path to the public key to be used for SSH access"
  default     = "~/.ssh/id_rsa.pub"
}

# The 'docker_image_tag' variable allows for specifying different versions of the Docker image to be deployed.
variable "docker_image_tag" {
  description = "Tag of the Docker image to deploy"
  default     = "latest"
}

# Outputs the public IP addresses of the deployed instances, 
# providing easy access to the IP addresses needed to connect to or access the web server.
output "instance_ips" {
  description = "Public IP addresses of the instances"
  value       = aws_instance.app.*.public_ip
}
