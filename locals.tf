# locals
######################################################################
#############            vpc cdr block        ########################
locals {
  vpc_cidr = "10.123.0.0/16"
}

######################################################################
############# public securty group protocols #########################
locals {
  securty_groups = {
    public = {
      name = "public_sg"
      description = "public securty group"
      ingress = {
        "80" = {int=80,ext=80,protocol="tcp",cidr_block=[var.access_ip]}
        "22" = {int=22,ext=22,protocol="tcp",cidr_block=[var.access_ip]}
      }
    }
    private = {
      name = "RDS_private_sg"
      description = "private securty group"
      ingress = {
        "80" = {int=3306,ext=3306,protocol="tcp",cidr_block=[local.vpc_cidr]}
      }
    }
  }
  
  
    
  
}
