output "instance_ips" {
  description = "Public IP addresses of the instances"
  value       = aws_instance.app.*.public_ip
}
