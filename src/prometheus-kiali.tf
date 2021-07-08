# Kiali
# https://kiali.io/documentation/latest/quick-start/#_install_via_kiali_server_helm_chart

# resource "helm_release" "kiali" {
#   name       = "kiali"
#   repository = "https://kiali.org/helm-charts"
#   chart      = "kiali-server"
#   version    = "v1.29.0"

#   set {
#     name  = "auth.strategy"
#     value = "anonymous"
#   }
#   set {
#     name  = "external_services.prometheus.url"
#     value = "http://prometheus-server.istio-system.svc.cluster.local:80"
#   }

#   namespace = kubernetes_namespace.istio_system.id
#   depends_on = [
#     kubernetes_namespace.istio_system , helm_release.prometheus
#   ]
#   wait = true
# }

# RUN if istioctl is installed: istioctl dashboard kiali
# or Run via port forwarding : kubectl port-forward svc/kiali 20001:20001 -n istio-system



# ----------------------------------------------------------------------------------------------------------------------
# prometheus
# ----------------------------------------------------------------------------------------------------------------------
# resource "kubernetes_namespace" "monitoring" {
#   metadata {
#     name = "monitoring"
#   }
# }

# locals {
#   helmChartValuesPrometheus = {
#     alertmanager = {
#       enabled = false
#     }
#     pushgateway = {
#       enabled = false
#     }
#     server = {
#       persistentVolume = {
#         enabled = false
#       }
#       global = {
#         scrape_interval = "15s"
#       }
#     }
#   }
# }

# resource "helm_release" "prometheus" {
#   name       = "prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus"
#   namespace = kubernetes_namespace.istio_system.id

#   values = [
#     yamlencode(local.helmChartValuesPrometheus)
#   ]

#   depends_on = [
#     helm_release.istio-base,
#     helm_release.istio-discovery
#   ]
# }