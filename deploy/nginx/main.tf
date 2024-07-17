locals {
  replicas        = 0
  container_port  = 80
}

data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "./terraform.tfstate"
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = var.kubernetes_deployment_nginx_name
    labels = {
      App = var.kubernetes_deployment_nginx_label
    }
  }

  spec {
    replicas = local.replicas
    selector {
      match_labels = {
        App = var.kubernetes_deployment_nginx_spec_label
      }
    }
    template {
      metadata {
        labels = {
          App = var.kubernetes_deployment_nginx_spec_label
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = var.kubernetes_deployment_nginx_spec_template_container_name

          port {
            container_port = local.container_port
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = var.kubernetes_service_nginx_name
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
