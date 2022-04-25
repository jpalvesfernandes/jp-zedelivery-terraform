resource "aws_lb" "jp-zedelivery-alb" {
  name               = "jp-zedelivery-alb"
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.jp-zedelivery-alb-sg.id]
}

resource "aws_lb_target_group" "jp-zedelivery-alb-tg-blue" {
  name        = "jp-zedelivery-alb-tg-blue"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main.id
  depends_on  = [aws_lb.jp-zedelivery-alb]
}

resource "aws_lb_listener" "jp-zedelivery-alb-listener-blue" {
  load_balancer_arn = aws_lb.jp-zedelivery-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jp-zedelivery-alb-tg-blue.arn
  }
}

resource "aws_lb_target_group" "jp-zedelivery-alb-tg-green" {
  name        = "jp-zedelivery-alb-tg-green"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main.id
  depends_on  = [aws_lb.jp-zedelivery-alb]
}

resource "aws_lb_listener" "jp-zedelivery-alb-listener-green" {
  load_balancer_arn = aws_lb.jp-zedelivery-alb.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jp-zedelivery-alb-tg-green.arn
  }
}