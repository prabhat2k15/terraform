# # Configure the Kubernetes provider
# provider "kubernetes" {
#   config_context_cluster = "my-kubernetes-cluster"
# }

# # Install the Amazon EFS CSI driver using a Helm chart
# resource "helm_release" "efs_csi_driver" {
#   name       = "efs-csi-driver"
#   repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"

#   chart = "aws-efs-csi-driver"

#   version = "1.3.2"

#   namespace = "kube-system"

#   set {
#     name  = "aws.region"
#     value = "us-west-2"
#   }

#   set {
#     name  = "dns.nameFormat"
#     value = "{{.Name}}.efs.us-west-2.amazonaws.com"
#   }

#   depends_on = [
#     kubernetes_namespace.namespace,
#   ]
# }

# # Create the kube-system namespace if it does not exist
# resource "kubernetes_namespace" "namespace" {
#   metadata {
#     name = "kube-system"
#   }
# }
