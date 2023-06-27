# locals {
#   kubeconfig = templatefile("templates/kubeconfig.tpl", {
#     kubeconfig_name                   = local.kubeconfig_name
#     endpoint                          = module.eks.cluster_endpoint
#     cluster_auth_base64               = module.eks.cluster_certificate_authority_data
#     aws_authenticator_command         = "aws-iam-authenticator"
#     aws_authenticator_command_args    = ["token", "-i", module.eks.cluster_name]
#     aws_authenticator_additional_args = []
#     aws_authenticator_env_variables   = {}
#   })
# }

# output "kubeconfig" { value = local.kubeconfig }

# # locals {
# #   kubeconfig = templatefile("templates/kubeconfig.tpl", {
# #     kubeconfig_name                   = local.kubeconfig_name
# #     endpoint                          = aws_eks_cluster.example.endpoint
# #     cluster_auth_base64               = aws_eks_cluster.example.certificate_authority[0].data
# #     aws_authenticator_command         = "aws-iam-authenticator"
# #     aws_authenticator_command_args    = ["token", "-i", aws_eks_cluster.example.name]
# #     aws_authenticator_additional_args = []
# #     aws_authenticator_env_variables   = {}
# #   })
# # }

# # output "kubeconfig" { value = local.kubeconfig }