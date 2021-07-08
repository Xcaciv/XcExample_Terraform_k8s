# Configuring terraform kubernetes provider with minikube context and pointing to local kube config
# privileged =true allows to run tcpdump on proxy sidecars
locals {
  kube_config = "~/.kube/config"

    helmChartValuesIstio = {
    global = {
      jwtPolicy = "first-party-jwt",
      proxy = {
      privileged =true
      }
    }
    gateways = {
      istio-ingressgateway = {
        type = "NodePort"
        # nodeSelector = {
        #   ingress-ready = "true"
        # }
        ports = [
          {
            port       = 15021
            targetPort = 15021
            nodePort   = 30002
            name       = "status-port"
            protocol   = "TCP"
          },
          {
            port       = 80
            targetPort = 8080
            nodePort   = 30000
            name       = "http2"
            protocol   = "TCP"
          },
          {
            port       = 443
            targetPort = 8443
            nodePort   = 30001
            name       = "https"
            protocol   = "TCP"
          }
        ]
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started
provider "kubernetes" {
  config_context_cluster   = "minikube"
  config_path = local.kube_config
}

# https://registry.terraform.io/providers/hashicorp/helm/latest/docs
provider "helm" {
  kubernetes {
    config_path = local.kube_config
  }
}


