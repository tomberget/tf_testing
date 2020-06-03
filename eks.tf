module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  subnets         = [aws_subnet.private_0.id, aws_subnet.private_1.id]
  vpc_id          = aws_vpc.default.id

  worker_groups_launch_template = [
    {
      name                    = "spot-1"
      override_instance_types = ["t3.small"]
      spot_instance_pools     = 2
      asg_max_size            = 2
      asg_desired_capacity    = 2
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
      public_ip               = true
    },
  ]
}