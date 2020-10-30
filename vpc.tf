# Create Elastic-IP for NAT-Gateway
resource "aws_eip" "nat" {
  count = length(var.vpc_azs)

  vpc = true

  tags = merge(var.tags, { "Name" = "${var.vpc_name}-natgw" })
}

# Create VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name             = var.vpc_name
  azs              = split(var.vpc_azs, ",")
  cidr             = var.vpc_cidr
  private_subnets  = split(var.private_subnets, ",")
  public_subnets   = split(var.public_subnets, ",")

  enable_nat_gateway = true
  single_nat_gateway = true
  #one_nat_gateway_per_az = true
  reuse_nat_ips          = true
  external_nat_ip_ids = aws_eip.nat.*.id

  tags = var.tags
}
