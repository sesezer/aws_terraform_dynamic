# networking/main
resource "random_integer" "random" {
    
    min = 1
    max = 100
  
}

resource "aws_vpc" "mtv_vpc" {
    enable_dns_hostnames = true
    enable_dns_support = true
    cidr_block = var.vpc_cidr
    tags = {
        Name = "mtc_vpc${random_integer.random.id}"
    }  
}