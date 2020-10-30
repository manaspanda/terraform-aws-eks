environment     = "stage"
#aws_profile     = "stage"
region          = "us-west-2"
vpc_azs         = "us-west-2a, us-west-2b"
vpc_name        = "acme-vpc-eks"
vpc_cidr        = "10.0.0.0/16"
public_subnets  = "10.0.16.0/24, 10.0.80.0/24"
private_subnets = "10.0.18.0/24, 10.0.82.0/24"

cluster_name = "acme-calico"

node_ami_type         = "AL2_x86_64"
node_instance_type    = "t2.large"
node_disk_size        = 50
node_desired_capacity = 2
node_max_capacity     = 10
node_min_capacity     = 2

tags = {
  environment      = "stage"
  application_name = "acme-calico"
  resource_owner   = "ACME Platform"
}

