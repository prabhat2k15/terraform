data "aws_kms_key" "by_key_arn" {
  key_id = "arn:aws:kms:us-east-1:647255248014:key/44d96ccf-30f1-4c24-b562-ef8857bba599"
}

locals {
  create_cluster_sg = false

}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.13.0"

  cluster_name    = "${var.env}-${var.cluster_name}"
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false


  # # cluster_security_group_id = aws_security_group.eks_cluster_sg.id

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnets_ids

  cluster_security_group_additional_rules = {
    ingress_vpn = {
      description              = "VPN sg"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = "sg-0c54490fde157678d"
    },
    ingress_alb = {
      description              = "ALB sg"
      protocol                 = "tcp"
      from_port                = 31410
      to_port                  = 31410
      type                     = "ingress"
      source_security_group_id = "sg-0e395f35a936f51a1"
    }
  }
  depends_on = [
    data.aws_kms_key.by_key_arn
  ]

  enable_irsa = true

  create_kms_key = false
  cluster_encryption_config = {
    provider_key_arn = data.aws_kms_key.by_key_arn.arn
    resources        = ["secrets"]
  }

  eks_managed_node_groups = {

    # general = {
    #   desired_size = 1
    #   min_size     = 1
    #   max_size     = 10

    #   labels = {
    #     role = "general"
    #   }

    #   instance_types = ["t3.large", "t3a.large", "m5.large"]
    #   capacity_type  = "ON_DEMAND"
    # }

    spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "spot"
      }
      iam_role_additional_policies = {
        iam_role_additional_policies = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      }

      #   taints = [{
      #     key    = "market"
      #     value  = "spot"
      #     effect = "NO_SCHEDULE"
      #   }]

      instance_types = ["t3.large", "t3a.large", "m5.large"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Name                                   = "${var.env}-${var.cluster_name}"
    Env                                    = "${var.env}"
    "k8s.io/cluster-autoscaler/my-cluster" = "owned"
    "k8s.io/cluster-autoscaler/enabled"    = "true"
  }
}

# resource "null_resource" "script" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#  provisioner "local-exec" {

#     # command = "/bin/bash script.sh"
#     command = "kubectl cluster-info && kubectl get nodes && kubectl apply -f ops "

#   }
#   depends_on = [
#     module.eks,
#     null_resource.kubectl
#   ]
# }

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
  }

  depends_on = [module.eks]
}

