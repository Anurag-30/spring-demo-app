module "network" {
  source                    = "./modules/network"
  cidr_block            = var.cidr_block
  number_of_private_subnets = var.number_of_private_subnets
  number_of_public_subnets  = var.number_of_public_subnets

}

module "eks" {
  source = "./modules/eks"
  private_subnets = module.network.private_subnets
  public_subnets = module.network.public_subnets
  depends_on = [module.network]
}