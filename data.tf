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

data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_authorizer.py"
  output_path = "${path.module}/lambda_authorizer.zip"
}
