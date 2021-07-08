
###################Install Istio (Service Mesh) #######################################

## https://istio.io/latest/docs/setup/install/helm/
## https://github.com/istio/istio/tree/master/manifests/charts/base

# Istio Base components like Custom Resource definitions

resource "helm_release" "istio-base" {
  namespace  = kubernetes_namespace.istio_system.id
  name       = "istio-base"
  chart      = "${path.module}/istio/manifests/charts/base"
  values = [
    yamlencode(local.helmChartValuesIstio)
  ]
}

# Istio Service Discovery helm chart

resource "helm_release" "istio-discovery" {
  namespace  = kubernetes_namespace.istio_system.id
  name       = "istio-discovery"
  chart      = "${path.module}/istio/manifests/charts/istio-control/istio-discovery"

  values = [
    yamlencode(local.helmChartValuesIstio)
  ]
  depends_on = [helm_release.istio-base]
}


# Istio Ingress gateway helm chart

resource "helm_release" "istio-ingress" {
  name       = "istio-ingress"
  chart      = "${path.module}/istio/manifests/charts/gateways/istio-ingress"
  namespace  = kubernetes_namespace.istio_system.id

  values = [
    yamlencode(local.helmChartValuesIstio)
  ]

  depends_on = [helm_release.istio-base]
}