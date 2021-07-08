resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
    labels = {
      namespace = "istio-system"
    }
      
  }
}


resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  

   labels = {
      istio-injection = "enabled",
      namespace = "databases"
    }
    }  
}


resource "kubernetes_namespace" "applications" {
  metadata {
    name = "applications"
  

   labels = {
      istio-injection = "enabled",
      namespace = "applications"
    }

    }  
}


resource "kubernetes_namespace" "apigateway" {
  metadata {
    name = "apigateway"
  

   labels = {
      istio-injection = "enabled",
      namespace = "apigateway"
    }
    }  
}
