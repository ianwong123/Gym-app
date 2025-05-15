module "network" {
  source = "./network"
  
  project_name   = var.project_name
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  db_subnets     = var.db_subnets
  nat_ami        = var.nat_ami
  nat_security_group_id = module.security.nat_security_group_id

}

module "security" {
  source = "./security"
  
  project_name   = var.project_name
  vpc_id = module.network.vpc_id
  vpc_cidr = var.vpc_cidr

  engine = var.engine
  engine_version = var.engine_version
  instance_type = var.instance_type
  db_name = var.db_name
  username = var.username
  password = var.password
}

module "compute" {
  source = "./compute"
  depends_on = [ module.network ]
  subnet_ids = module.network.subnet_ids
  web_security_group_id = module.security.web_security_group_id
  app_security_group_id = module.security.app_security_group_id
  bastion_security_group_id = module.security.bastion_security_group_id
}

module "data" {
  source = "./data"
  engine = var.engine
  engine_version = var.engine_version
  instance_type = var.instance_type
  db_name = var.db_name
  username = var.username
  password = var.password
  subnet_ids = module.network.subnet_ids
  rds_security_group_id = module.security.rds_security_group_id
}





