variable "managed_work_group_one_name" {
  type        = string
  default     = "node-group-1"
}

variable "managed_work_group_two_name" {
  type        = string
  default     = "node-group-2"
}

variable "kubernetes_service_nginx_name" {
  type        = string
  default     = "mht-nginx-app"
}

variable "kubernetes_deployment_nginx_name" {
  type        = string
  default     = "mht-nginx"
}

variable "kubernetes_deployment_nginx_label" {
  type        = string
  default     = "mht-nginx-label"
}

variable "kubernetes_deployment_nginx_spec_label" {
  type        = string
  default     = "mht-nginx-scalable"
}

variable "kubernetes_deployment_nginx_spec_template_container_name" {
  type        = string
  default     = "mht-nginx-container"
}
