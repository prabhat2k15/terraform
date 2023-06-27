# output "cluster-sg" {
#   value = aws_security_group.eks_cluster_sg.id
# }
# output "node-sg" {
#   value = aws_security_group.eks_worker_nodes_sg.id
# }
output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}
output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}
output "eks_managed_node_groups_autoscaling_group_names" {
  value = module.eks.eks_managed_node_groups_autoscaling_group_names
}
output "cluster_arn" {
  value = module.eks.cluster_arn
}
output "oidc_provider" {
  value = module.eks.oidc_provider
}
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}
output "cluster_name" {
  value = module.eks.cluster_name
}
output "cluster_id" {
  value = module.eks.cluster_id
}

#Nodes
output "worker_node" {
  value = module.eks.eks_managed_node_groups
}

#KMS
output "kmsarn" {
  value = data.aws_kms_key.by_key_arn.id
}

# ALB
output "alb" {
  value = aws_lb.test.dns_name
}
output "alb_sg" {
  value = aws_lb.test.security_groups
}
# output "alb" {
#   value = aws_lb.tg.arn
# }
# # KUBECONFIG
# output "kubeconfig" {
#   value = module.eks-kubeconfig
#   sensitive = true
# }