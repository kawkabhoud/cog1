resource "aws_lb" "lb" {
  name                       = var.lb_settings.name
  internal                   = var.lb_settings.internal
  load_balancer_type         = var.lb_settings.load_balancer_type
  subnets                    = var.lb_settings.subnets   #[for subnet in aws_subnet.public : subnet.id]
  enable_deletion_protection = var.lb_settings.enable_deletion_protection
  tags                       = var.lb_settings.tags
}

resource "aws_lb_target_group" "tg" {
  name     = var.lb_settings.tg_name     #"TTA-lb-alb-tg"
  port     = var.lb_settings.tg_port     #"80"
  protocol = var.lb_settings.tg_protocol #"HTTP"
  vpc_id   = var.lb_settings.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "tg443" {
  name     = var.lb_settings.tg443_name
  port     = var.lb_settings.tg443_port
  protocol = var.lb_settings.tg443_protocol
  vpc_id   = var.lb_settings.vpc_id
  target_type = "ip"
}


#Create LB Listeners
resource "aws_lb_listener" "lstn" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.lb_settings.lstn_port     #"80"
  protocol          = var.lb_settings.lstn_protocol #"HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
resource "aws_lb_listener" "lstn443" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.lb_settings.lstn443_port
  protocol          = var.lb_settings.lstn443_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg443.arn
  }
}
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = length(var.lb_settings.target_id)

  target_group_arn = aws_lb_target_group.tg443.arn
  target_id        = element(var.lb_settings.target_id,count.index)
}
