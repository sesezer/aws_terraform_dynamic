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

resource "aws_subnet" "mtv_public_subnet" {
    depends_on = [ aws_vpc.mtv_vpc ]
    vpc_id = aws_vpc.mtv_vpc.id
    count = var.public_sub_count
    map_public_ip_on_launch = true
    cidr_block = var.public_sec[count.index]
    availability_zone = ["eu-west-1a","eu-west-1b","eu-west-1c"][count.index]
    tags = {
      Name = "mtv_vpc-public${count.index + 1}"
    }

              
}
resource "aws_subnet" "mtv_private_subnet" {
    depends_on = [ aws_vpc.mtv_vpc ]
    vpc_id = aws_vpc.mtv_vpc.id
    count = var.private_sub_count
    availability_zone = ["eu-west-1a","eu-west-1b","eu-west-1c"][count.index]
    map_public_ip_on_launch = false
    cidr_block = var.private_sec[count.index]
    tags = {
      Name = "mtv_vpc-private${count.index + 1}"
    }
      
}