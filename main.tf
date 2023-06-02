# main.tf


module "networking" {
    source = "./networking"
    vpc_cidr = "10.123.0.0/16"
    public_sec = ["10.123.10.0/24","10.123.20.0/24"]
    private_sec = ["10.123.11.0/24","10.123.21.0/24","10.123.31.0/24"]
}