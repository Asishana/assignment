terraform {
  backend "s3" {
    bucket         = "medicate-dev-terraform-state"     # Replace with your bucket
    key            = "flask-app/terraform.tfstate"   # Path within the bucket
    region         = "us-east-1"
  }
}

module "networking" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.networking.vpc_id
}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  security_groups = [module.security_groups.ecs_sg_id]
}

module "ecs" {
  source          = "./modules/ecs"
  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  security_groups = [module.security_groups.ecs_sg_id]
  alb_target_group_arn = module.alb.target_group_arn
}