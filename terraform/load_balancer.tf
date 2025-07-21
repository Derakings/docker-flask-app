resource "aws_lb" "flask_app_alb" {
  name               = "flask-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets[*].id

  enable_deletion_protection = false

  tags = {
    Name = "flask-app-alb"
  }
}

# Target Group for Load Balancer
resource "aws_lb_target_group" "flask_app_tg" {
  name     = "flask-app-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.flask_app_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "flask-app-tg"
  }
}



# Load Balancer Listener
resource "aws_lb_listener" "flask_app_listener" {
  load_balancer_arn = aws_lb.flask_app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_app_tg.arn
  }
}