# main.tf

locals {
  vpc_cidr = "10.123.0.0/16"
}

module "networking" {
    source = "./networking"
    vpc_cidr = "10.123.0.0/16"
    access_ip = var.access_ip
    public_sub_count = 2
    private_sub_count = 3
    public_sec = [for i in range(2,255,2): cidrsubnet("10.123.0.0/16",8,i)]
    private_sec = [for i in range(1,255,2): cidrsubnet("10.123.0.0/16",8,i)]
}