data "http" "my_ip" {
  url = "https://ifconfig.me"
}

module "network" {
  source = "./modules/network"

  pj_name                = "training-tf"
  vpc_cidr               = "13.0.0.0/16"
  public_subnet_cidr     = "13.0.0.0/24"
  private_1a_subnet_cidr = "13.0.1.0/24"
  private_1c_subnet_cidr = "13.0.2.0/24"
}

module "compute" {
  source = "./modules/compute"

  pj_name          = "training-tf"
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
  security_group_ingress_rules = [
    {
      cidr      = "${data.http.my_ip.response_body}/32"
      from_port = "22"
      to_port   = "22"
    },
    {
      cidr      = "0.0.0.0/0"
      from_port = "80"
      to_port   = "80"
    }
  ]
}

module "database" {
  source = "./modules/database"

  pj_name              = "training-tf"
  vpc_id               = module.network.vpc_id
  private_1a_subnet_id = module.network.private_1a_subnet_id
  private_1c_subnet_id = module.network.private_1c_subnet_id
  security_group_ingress_rules = {
    referenced_security_group_id = module.compute.referenced_security_group_id
    from_port                    = "3306"
    to_port                      = "3306"
  }
  rds_username = "admin"
  rds_password = "Passworddesu" # 本来ここに記述すべきではない（tfvarsファイル等に書く）
}
