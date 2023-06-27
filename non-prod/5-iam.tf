# IAM role for cluster autoscaler
data "aws_iam_policy_document" "kubernetes_cluster_autoscaler_assume" {

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:cluster-autoscaler",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "kubernetes_cluster_autoscaler" {
  name               = "${module.eks.cluster_name}-cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_cluster_autoscaler_assume.json
}

output "cluster-as-role" {
  value = aws_iam_role.kubernetes_cluster_autoscaler.arn
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name = "${module.eks.cluster_name}-cluster-autoscaler-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/k8s.io/cluster-autoscaler/${module.eks.cluster_name}" : "owned"
          }
        }
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeAutoScalingGroups",
          "ec2:DescribeLaunchTemplateVersions",
          "autoscaling:DescribeTags",
          "autoscaling:DescribeLaunchConfigurations"
        ],
        "Resource" : "*"
      }
    ]
  })
}

data "aws_iam_policy" "load_balancer_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
}
output "load_balancer_policy" {
  value = data.aws_iam_policy.load_balancer_policy.arn
  
}
resource "aws_iam_role_policy_attachment" "eks_ca_iam_policy_attach" {
  role       = aws_iam_role.kubernetes_cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}

resource "aws_iam_role_policy_attachment" "eks_lb_iam_policy_attach" {
  role       = aws_iam_role.kubernetes_cluster_autoscaler.name
  policy_arn = data.aws_iam_policy.load_balancer_policy.arn
}