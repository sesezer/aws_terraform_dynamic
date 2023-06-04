# loadbalancer/output


output "target_group_arn" {
    value = aws_alb_target_group.mtv_tg.arn
  
}