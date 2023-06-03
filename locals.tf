# locals

locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  
    public = {
        "80" = {int=80,ext=80,protocol="tcp"}
        "443" = {int=443,ext=443,protocol="tcp"}
        "22" = {int=22,ext=22,protocol="tcp"}
    }
  
}