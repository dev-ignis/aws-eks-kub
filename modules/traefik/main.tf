provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "20.4.0"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "ports.web.port"
    value = "80"
  }

  set {
    name  = "ports.websecure.port"
    value = "443"
  }

  set {
    name  = "additionalArguments[0]"
    value = "--api.insecure=true"
  }

  set {
    name  = "additionalArguments[1]"
    value = "--api.dashboard=true"
  }

  set {
    name  = "additionalArguments[2]"
    value = "--entryPoints.dashboard.address=:8080"
  }

  set {
    name  = "entrypoints.dashboard.address"
    value = ":8080"
  }

  set {
    name  = "service.annotations.traefik\\.http\\.routers\\.api\\.service"
    value = "api@internal"
  }

  set {
    name  = "service.annotations.traefik\\.http\\.routers\\.api\\.rule"
    value = "Host(`traefik.localhost`)"
  }

  set {
    name  = "service.annotations.traefik\\.http\\.routers\\.api\\.entrypoints"
    value = "web"
  }
}

output "traefik_dashboard_url" {
  value = "http://traefik.localhost"
}
