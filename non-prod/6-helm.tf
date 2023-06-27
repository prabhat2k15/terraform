

resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-external"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "nginx-ingress-external"
  create_namespace = true

  set {
    name  = "controller.metrics.service.servicePort"
    value = "80"
  }
  set {
    name  = "controller.ingressClass"
    value = "nginx-ingress-external"
  }
  set {
    name  = "controller.ingressClassResource.name"
    value = "nginx-ingress-external"
  }
  set {
    name  = "controller.ingressClassResource.controllerValue"
    value = "k8s.io/ingress-nginx"
  }
  set {
    name  = "controller.ingressClassResource.enabled"
    value = "true"
  }
  set {
    name  = "controller.ingressClassByName"
    value = "true"
  }
  set {
    name  = "controller.ingressClassResource.name"
    value = "nginx-ingress-external"
  }
  set {
    name  = "controller.service.nodePorts.http"
    value = "31410"
  }
  set {
    name  = "controller.service.nodePorts.https"
    value = "32012"
  }
  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  depends_on = [
    module.eks,
    helm_release.aws_load_balancer_controller
  ]
}



######################################################################

resource "helm_release" "aws_load_balancer_controller" {
  name = "aws-load-balancer-controller"

  repository       = "eks/aws-load-balancer-controller"
  chart            = "eks/aws-load-balancer-controller"
  namespace        = "kube-system"
  #   create_namespace = false

  set {
    name  = "clusterName"
    value = "non-prod-eks-cluster"
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  depends_on = [
    module.eks
  ]
}

######################################################################
# Prometheus
# kubectl create namespace prometheus

# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# helm install prometheus prometheus-community/prometheus \
#     --namespace prometheus \
#     --set alertmanager.persistentVolume.storageClass="gp2" \
#     --set server.persistentVolume.storageClass="gp2"





######################################################################

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
#     value = "{{.Name}}.efs.us-east-1.amazonaws.com"
#   }

#   depends_on = [
#     module.eks
#   ]
# }



################################################################

resource "null_resource" "crd" {
  triggers = {
    eks_id = module.eks.cluster_id
  }
 provisioner "local-exec" {

    command = "kubectl apply -f ops/crd.yaml"
  }
  depends_on = [
    module.eks,
    null_resource.kubectl,
    helm_release.aws_load_balancer_controller
  ]
}

resource "null_resource" "tgb" {
  triggers = {
    eks_id = module.eks.cluster_id
  }
 provisioner "local-exec" {
    command = "kubectl apply -f ops/tgb.yaml"

  }
  depends_on = [
    module.eks,
    null_resource.kubectl,
    helm_release.aws_load_balancer_controller
  ]
}

resource "null_resource" "ca" {
  triggers = {
    eks_id = module.eks.cluster_id
  }
 provisioner "local-exec" {
    command = "kubectl apply -f ops/cluster-autoscaler-autodiscover.yaml"

  }
  depends_on = [
    module.eks,
    null_resource.kubectl,
    helm_release.aws_load_balancer_controller
  ]
}

resource "null_resource" "metrics-server" {
  triggers = {
    eks_id = module.eks.cluster_id
  }
 provisioner "local-exec" {
    command = "kubectl apply -f ops/metrics-server.yaml"

  }
  depends_on = [
    module.eks,
    null_resource.kubectl,
    helm_release.aws_load_balancer_controller
  ]
}