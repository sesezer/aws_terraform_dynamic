variable "access_ip" {description = "access ips for public sec group"}
variable "dbname" {}
variable "dbusername" {sensitive = true}
variable "dbpassword" {sensitive = true}