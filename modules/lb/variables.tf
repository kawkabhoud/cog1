variable "lb_settings" {
  default = {
    name               = "cognos-nlb"
    internal           = true
    load_balancer_type = "network"
    subnets            = []#[for subnet in aws_subnet.public : subnet.id]
    enable_deletion_protection = false
    tags                       = { Environment = "dev" }
    tg_name                    = "cognos-nlb-tg"
    tg443_name                 = "cognos-nlb-tg443"
    tg_port                    = "80"
    tg443_port                 = "443"
    tg_protocol                = "TCP"
    tg443_protocol             = "TCP"
    lstn_port     = "80"
    lstn443_port  = "443"
    lstn_protocol = "HTTP"
    lstn443_protocol = "HTTPS"
    vpc_name = "Default"
  }
}
