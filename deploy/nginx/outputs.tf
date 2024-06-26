output "lb_ip" {
  description = "Load Balancer IP"
  value = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname
}
