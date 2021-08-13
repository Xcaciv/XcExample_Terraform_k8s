
# XC apps 
# Local Helm chart in folder : xc-apps

 resource "helm_release" "xc-apps" {
   name       = "xc-apps"
   chart      = "${path.module}/xc-apps"

   depends_on = [helm_release.istio-base]
 }