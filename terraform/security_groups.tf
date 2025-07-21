
# Security Group for Load Balancer
resource "aws_security_group" "alb_sg" {
  name_prefix = "flask-app-alb"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.flask_app_vpc.id


  # Allow HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-app-alb-sg"
  }
}

# Security Group for EC2 instance
resource "aws_security_group" "flask_app_sg" {
  name_prefix = "flask-app-ec2"
  description = "Security group for Flask app EC2 instance"
  vpc_id      = aws_vpc.flask_app_vpc.id

  # Allow SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Flask app (port 5000) from ALB security group
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-app-ec2-sg"
  }
}