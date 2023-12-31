## compute/main



data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["099720109477"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20220118"]
    }
  
}

resource "aws_instance" "mtv_instance" {
    count = var.instance_count
    instance_type = var.instance_type

    ami = data.aws_ami.server_ami.id
    vpc_security_group_ids = var.public_sg
    subnet_id = var.instance_public_subnet[count.index]
    tags = {
      Name = "mtc-node${count.index}"
    }
    root_block_device {
        volume_size = var.volume_size
    
    }
    key_name = aws_key_pair.mtv_key.key_name
    user_data = templatefile(var.userdata_path,{
      nodename = "mtc-node${count.index}"
      db_endpoint = var.db_endpoint
      dbuser = var.db_user
      dbpass = var.dbpassword
      dbname = var.db_name
    })
    
  
}
resource "aws_key_pair" "mtv_key" {
    key_name = var.key_name
    public_key = file(var.mtc_publickey_path)
    
}

resource "aws_lb_target_group_attachment" "mtv_targetgroup" {
  count = var.instance_count
  port = 8000
  target_group_arn = var.lb_target_group_arn
  target_id = aws_instance.mtv_instance[count.index].id
      
}