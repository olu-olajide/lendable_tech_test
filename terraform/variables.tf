variable "instance_count" {
  description = "The number of instances to deploy."
  type        = number
  default     = 3
}

variable "public_key_path" {
  description = "Path to the public key to be used for SSH access"
  default     = "~/.ssh/id_rsa.pub"
}

variable "docker_image_tag" {
  description = "Tag of the Docker image to deploy"
  default     = "latest"
}