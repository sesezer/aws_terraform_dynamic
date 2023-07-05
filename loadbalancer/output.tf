# loadbalancer/output


output "target_group_arn" {
    value = aws_alb_target_group.mtv_tg.arn
  
}

output "loadbalancer_dns" {
    value = aws_lb.mtv_lb.dns_name
  
}