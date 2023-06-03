# networking/main
resource "random_integer" "random" {
    
    min = 1
    max = 100
  
}
data "aws_availability_zones" "available" {}

resource "aws_vpc" "mtv_vpc" {
    enable_dns_hostnames = true
    enable_dns_support = true
    cidr_block = var.vpc_cidr
    tags = {
        Name = "mtc_vpc${random_integer.random.id}"
    }  
}
resource "random_shuffle" "az" {
    input = data.aws_availability_zones.available.names
    result_count = max(var.public_sub_count,var.private_sub_count)
     
}


resource "aws_subnet" "mtv_public_subnet" {
    depends_on = [ aws_vpc.mtv_vpc ]
    vpc_id = aws_vpc.mtv_vpc.id
    count = var.public_sub_count
    map_public_ip_on_launch = true
    cidr_block = var.public_sec[count.index]
    availability_zone = random_shuffle.az.result[count.index]
    tags = {
      Name = "mtv_vpc-public${count.index + 1}"
    }

              
}
resource "aws_subnet" "mtv_private_subnet" {
    depends_on = [ aws_vpc.mtv_vpc ]
    vpc_id = aws_vpc.mtv_vpc.id
    count = var.private_sub_count
    availability_zone = random_shuffle.az.result[count.index]
    map_public_ip_on_launch = false
    cidr_block = var.private_sec[count.index]
    tags = {
      Name = "mtv_vpc-private${count.index + 1}"
    }
      
}