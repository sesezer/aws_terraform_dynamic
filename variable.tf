variable "access_ip" {description = "access ips for public sec group"}
variable "dbname" {}
variable "dbusername" {sensitive = true}
variable "dbpassword" {sensitive = true}
variable "access_key" {sensitive = true}
variable "secret_key" {sensitive = true}