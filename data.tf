data "kubernetes_service" "app_loadbalancer_service" {

  metadata {
    name      = "svc-app-loadbalancer"
    namespace = "default"
  }

}


data "aws_eks_cluster" "cluster" {
  name = "ordering-eks-cluster"
}

data "aws_eks_cluster_auth" "auth" {
  name = "ordering-eks-cluster"
}
