# networking/out

output "vpc_id" {
    value = aws_vpc.mtv_vpc.id
  
}
output "db_subnet_group_name" {
    value = aws_db_subnet_group.mtv_subnet_group.*.name
  
}
output "db_securty_group_id" {
    value = [aws_security_group.mtv_sg["private"].id]
  
}
output "db_securty_group_public" {
    value = [aws_security_group.mtv_sg["public"].id]
  
}
output "public_subnets_mtv" {
    
    value = (aws_subnet.mtv_public_subnet[*].id)
  
}