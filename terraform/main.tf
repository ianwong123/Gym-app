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
}




