output "load_balancer_hostname" {
  value = data.kubernetes_service.app_loadbalancer_service.status[0].load_balancer[0].ingress[0].hostname
}