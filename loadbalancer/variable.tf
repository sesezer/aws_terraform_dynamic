## loadbalancer/variable
variable "lb_securty_group" {}
variable "lb_subnets" {}

##### target group #########
variable "tg_port" {}
variable "tg_protocol" {}
variable "vpc_id" {}
variable "lb_healtythreshold" {}
variable "lb_unhealthythreshold" {}
variable "lb_timeout" {}
variable "lb_interval" {}

###### listener ##########

variable "listener_port" {}
variable "listener_protocol" {}

