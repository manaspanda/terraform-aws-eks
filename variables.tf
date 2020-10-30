variable "aws_profile" {
}

variable "vpc_name" {
}

variable "vpc_azs" {
}

variable "vpc_cidr" {
}

variable "public_subnets" {
}

variable "private_subnets" {
}

variable "environment" {
}

variable "region" {
  default = "us-west-2"
}

variable "tags" {
  type = map(string)
}

variable "cluster_name" {
}

variable "node_ami_type" {
}

variable "node_instance_type" {
}

variable "node_disk_size" {
}

variable "node_desired_capacity" {
}

variable "node_max_capacity" {
}

variable "node_min_capacity" {
}

