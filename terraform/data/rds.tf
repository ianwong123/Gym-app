resource "aws_db_instance" "rds-primary" {
    identifier = "${var.project_name}-rds"
    allocated_storage = 10

    engine = var.engine
    engine_version = var.engine_version
    instance_class = var.instance_type
    db_name = var.db_name
    username = var.username
    password = var.password
    port = 3306

    multi_az = true
    skip_final_snapshot = true
    publicly_accessible = false
    storage_encrypted = true
    backup_retention_period = 7
    
    parameter_group_name = aws_db_parameter_group.rds_parameter_group.name
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [var.rds_security_group_id]
    
    tags = {
        Name = "${var.project_name}-rds"
    }
}

resource "aws_db_parameter_group" "rds_parameter_group" {
    name = "${var.project_name}-rds-parameter-group"
    family = "mysql8.0"
    description = "RDS parameter group for ${var.project_name}"
    
    tags = {
        Name = "${var.project_name}-rds-parameter-group"
    }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "${var.project_name}-rds-subnet-group-main"
    subnet_ids = [var.subnet_ids.db_az1, var.subnet_ids.db_az2] 
    description = "RDS subnet group for AZ1 and AZ2"
    
    tags = {
        Name = "${var.project_name}-rds-subnet-group"
    }
} 