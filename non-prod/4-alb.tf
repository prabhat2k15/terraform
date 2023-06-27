resource "aws_lb" "test" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = var.public_subnets_ids

  enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.env}-lb-tg"
  port     = 31410
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# resource "aws_lb_target_group_attachment" "tg_attach" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id        = aws_lb.test.id
#   port             = 80
# }

resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg.id
    type             = "forward"
  }
  depends_on        = [
    aws_lb.test
  ]
}
resource "aws_alb_listener" "ssl" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:647255248014:certificate/54a30fc2-bfb5-44ee-8b8c-a995c7954578"
  depends_on        = [
    aws_lb.test
  ]
   
  default_action {
    target_group_arn = aws_lb_target_group.tg.id
    type             = "forward"
  }
}


# Create security group for ALB
resource "aws_security_group" "alb-sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env}-alb-sg"
    ManagedBy   = "terrafom"
    Environment = "${var.env}"
  }
}

