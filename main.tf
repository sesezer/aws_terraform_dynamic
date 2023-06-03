# main.tf



module "networking" {
    source = "./networking"
    vpc_cidr = local.vpc_cidr
    access_ip = var.access_ip
    public_sg_protocol = local.public
    public_sub_count = 2
    private_sub_count = 3
    public_sec = [for i in range(2,255,2): cidrsubnet(local.vpc_cidr,8,i)]
    private_sec = [for i in range(1,255,2): cidrsubnet(local.vpc_cidr,8,i)]
}