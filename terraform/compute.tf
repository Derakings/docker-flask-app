# EC2 Instance
resource "aws_instance" "flask_app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.existing_key_pair_name
  subnet_id              = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.flask_app_sg.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    docker_image = var.docker_image
  }))

  tags = {
    Name = "flask-app-server"
  }
}

# Attach instance to target group
resource "aws_lb_target_group_attachment" "flask_app_tg_attachment" {
  target_group_arn = aws_lb_target_group.flask_app_tg.arn
  target_id        = aws_instance.flask_app.id
  port             = 5000
}