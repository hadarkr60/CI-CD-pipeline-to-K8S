module "network_dev" {
  source                     = "./modules/network_dev" 
  region                     = var.region
  project_tag                = var.project_tag
  instaces_availability_zone = var.az
}

module "jenkins" { 
  source                      = "./modules/jenkins"  
  vpc_id                      = module.network_dev.vpc_id
  private_subnet_id           = module.network_dev.private_subnet_id
  private_subnet_cidr         = module.network_dev.private_subnet_cidr
  project_tag                 = var.project_tag
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  alb_security_group          = module.alb_development_vpc.alb_security_group_id
  instances_availability_zone = var.az
}

module "gitlab" {
  source                      = "./modules/gitlab"
  vpc_id                      = module.network_dev.vpc_id
  private_subnet_id           = module.network_dev.private_subnet_id
  private_subnet_cidr         = module.network_dev.private_subnet_cidr
  project_tag                 = var.project_tag
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  alb_security_group          = module.alb_development_vpc.alb_security_group_id
  instances_availability_zone = var.az
}

module "eks" {
  cluster_version      = "1.25"
  source               = "./modules/eks"
  cluster_name         = var.cluster_name
  vpc_cidr             = "10.0.0.0/16"
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]  
  public_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]  
  availability_zones   = ["us-east-1a", "us-east-1b"]    
  project_tag          = var.project_tag
}

module "lb_controller" {
  source            = "./modules/lb_controller"  
  region            = var.region                  
  cluster_name      = var.cluster_name
  project_tag       = var.project_tag 
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url   = module.eks.oidc_issuer_url            
}

module "alb_development_vpc" {
  source              = "./modules/alb_development_vpc"
  vpc_id              = module.network_dev.vpc_id
  public_subnet_ids   = module.network_dev.public_subnet_ids
  gitlab_private_ip   = module.gitlab.gitlab_instance_private_ip
  jenkins_private_ip  = module.jenkins.jenkins_instance_private_ip
  project_tag         = var.project_tag
}
