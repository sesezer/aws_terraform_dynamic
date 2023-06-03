# database/main

resource "aws_db_instance" "mtv_rds" {
    allocated_storage = var.db_storage
    engine = "mysql"
    engine_version = var.db_engine_version
    instance_class = var.db_instance_class
    name = var.db_name
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = var.db_db_subnet_group_name
    vpc_security_group_ids = var.db_securty_group_id
    identifier = var.db_identifier
    skip_final_snapshot = var.db_skip_final_snapshot
    tags = {
      Name = "mtv_db"
    }
  
}
