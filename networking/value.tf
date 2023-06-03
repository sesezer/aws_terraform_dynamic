# networking/value

variable "vpc_cidr" {description = "cidr block for mtc_vpc"}
variable "public_sec" {description = "cidr block for public subnet"}
variable "private_sec" {description = "cidr block for private subnet"}
variable "public_sub_count" {description = "how many public subnet"}
variable "private_sub_count" {description = "how many private subnet"}
variable "access_ip" {description = "access to public securty group"}