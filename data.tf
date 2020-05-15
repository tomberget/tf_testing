# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {

}

data "aws_availability_zones" "available" {

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}