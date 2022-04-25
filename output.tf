
output "alb-endpoint" {
  value = aws_lb.jp-zedelivery-alb.dns_name
}