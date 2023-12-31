# main.tf



module "networking" {
    source = "./networking"
    vpc_cidr = local.vpc_cidr
    access_ip = var.access_ip
    securty_groups = local.securty_groups
    db_subnet_group = true
    public_sub_count = 2
    private_sub_count = 3
    public_sec = [for i in range(2,255,2): cidrsubnet(local.vpc_cidr,8,i)]
    private_sec = [for i in range(1,255,2): cidrsubnet(local.vpc_cidr,8,i)]
}

module "database" {
    source = "./database"
    db_storage = 10
    db_engine_version = "5.7.37"
    db_instance_class = "db.t3.micro"
    db_name = var.dbname
    db_username = var.dbusername
    db_password = var.dbpassword
    db_db_subnet_group_name = module.networking.db_subnet_group_name[0]
    db_securty_group_id = module.networking.db_securty_group_id
    db_identifier = "mtc-db"
    db_skip_final_snapshot = true
}

module "loadbalancer" {
    source = "./loadbalancer"
    lb_securty_group = module.networking.db_securty_group_public
    lb_subnets = module.networking.public_subnets_mtv
    tg_port =   80
    tg_protocol = "HTTP"
    vpc_id = module.networking.vpc_id
    lb_healtythreshold = 2                                        
    lb_unhealthythreshold = 2
    lb_timeout = 10
    lb_interval = 30
    listener_port = 80
    listener_protocol = "HTTP"
}

module "compute" {
    source = "./compute"
    instance_count = 2
    public_sg = module.networking.db_securty_group_public
    instance_public_subnet = module.networking.public_subnets_mtv
    volume_size = 10
    instance_type = "t3.micro"
    key_name = "mtckey"
    mtc_publickey_path = "/home/sezer/.ssh/mtc_instance.pub"
    userdata_path = "${path.root}/userdata.tpl"
    db_endpoint = module.database.db_endpoint  
    db_user = var.dbusername
    dbpassword = var.dbpassword
    db_name = var.dbname
    lb_target_group_arn = module.loadbalancer.target_group_arn
}