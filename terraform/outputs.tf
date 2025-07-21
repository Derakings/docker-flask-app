# terraform/outputs.tf
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.flask_app_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.flask_app.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.flask_app.public_dns
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.flask_app_alb.dns_name
}

output "load_balancer_url" {
  description = "URL to access the Flask application through load balancer"
  value       = "http://${aws_lb.flask_app_alb.dns_name}"
}

output "flask_app_direct_url" {
  description = "Direct URL to access the Flask application"
  value       = "http://${aws_instance.flask_app.public_ip}:5000"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/${var.existing_key_pair_name}.pem ubuntu@${aws_instance.flask_app.public_ip}"
}
