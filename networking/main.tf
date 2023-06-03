# networking/main
resource "random_integer" "random" {
    
    min = 1
    max = 100
  
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "mtv_vpc" {
    enable_dns_hostnames = true
    enable_dns_support = true
    lifecycle {
      create_before_destroy = true
    }
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

resource "aws_internet_gateway" "mtv_vpc" {
    vpc_id = aws_vpc.mtv_vpc.id
  
}
############## mtv route table ##############################
resource "aws_route_table" "mtv_public" {
    vpc_id = aws_vpc.mtv_vpc.id
    tags = {
        Name = "mtv_public"
    }
    
}

resource "aws_route_table_association" "public" {
    count = var.public_sub_count
    subnet_id = aws_subnet.mtv_public_subnet.*.id[count.index]
    route_table_id = aws_route_table.mtv_public.id
  
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.mtv_public.id
    gateway_id = aws_internet_gateway.mtv_vpc.id
    destination_cidr_block = "0.0.0.0/0"
     
}
##############################################################
############## securty group #################################
resource "aws_security_group" "mtv_sg" {
    for_each = var.securty_groups
    vpc_id = aws_vpc.mtv_vpc.id
    name = each.value.name
    description = each.value.description
    dynamic "ingress" {
        for_each = each.value.ingress
        content {
          from_port = ingress.value.int
          to_port = ingress.value.ext
          protocol = ingress.value.protocol
          cidr_blocks = ingress.value.cidr_block
        }
      
    }
    egress {
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "-1"
    }
    tags = {
      Name = each.value.name
    }
  
}

resource "aws_db_subnet_group" "mtv_subnet_group" {
    name = "mtv_rdssubnet_group"
    subnet_ids = aws_subnet.mtv_private_subnet.*.id
    count = var.db_subnet_group ? 1 : 0
    tags = {
      Name = "mtv_rdssubnet_group"
    }
  
}