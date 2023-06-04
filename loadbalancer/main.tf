#### loadbalancer/main.tf

resource "aws_lb" "mtv_lb" {
    name = "mtvlb"
    load_balancer_type = "application"
    security_groups = var.lb_securty_group
    subnets = var.lb_subnets
    idle_timeout = 400
        
  
}

resource "aws_alb_target_group" "mtv_tg" {
    
    name = "mtv-lb-tg${substr(uuid(), 0, 3)}"
    port = var.tg_port # 80
    protocol = var.tg_protocol
    vpc_id = var.vpc_id
    health_check {
        healthy_threshold = var.lb_healtythreshold
        unhealthy_threshold = var.lb_unhealthythreshold
        timeout = var.lb_timeout
        interval = var.lb_interval
    }
  
}
resource "aws_lb_listener" "mtv_tg_listener" {
    load_balancer_arn = aws_lb.mtv_lb.arn
    port = var.listener_port
    protocol = var.listener_protocol
    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.mtv_tg.arn
    }
  
}