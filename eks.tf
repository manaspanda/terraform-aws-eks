module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_version = "1.17"
  cluster_name    = var.cluster_name

  vpc_id = module.vpc.vpc_id
  #subnets = split(",", var.eks_subnet_ids)
  subnets = module.vpc.private_subnets

  cluster_endpoint_private_access       = true
  cluster_endpoint_private_access_cidrs = ["0.0.0.0/0"]
  cluster_endpoint_public_access        = false

  node_groups_defaults = {
    ami_type  = var.node_ami_type
    disk_size = var.node_disk_size
    #subnets   = split(",", var.worker_subnet_ids)
    subnets = module.vpc.private_subnets
  }

  node_groups = {
    workers = {
      instance_type    = var.node_instance_type
      desired_capacity = var.node_desired_capacity
      max_capacity     = var.node_max_capacity
      min_capacity     = var.node_min_capacity
      k8s_labels       = var.tags
    }
  }

  tags = var.tags
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}
