
# PostgreSQL helm chart from bitnami
# https://bitnami.com/stack/postgresql/helm
// helm.sh/chart=postgresql-10.7.1
resource "helm_release" "postgres" {
  chart = "bitnami/postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  name = "my-app-postgres"
  version    = "10.7.1"
  namespace = kubernetes_namespace.databases.id

  set {
    name = "image.repository"
    value = "postgres"
  }

  set {
    name = "image.tag"
    value = "12.2"
  }

  set {
    name = "postgresqlUsername"
    value = "postgres"
  }

  set {
    name = "postgresqlPassword"
    value = "some_password777"
  }

  set {
    name = "postgresqlDatabase"
    value = "temporaryDbName"
  }

   set {
    name = "serviceAccount.enabled"
    value = "true"
  }

   set {
    name = "serviceAccount.autoMount"
    value = "true"
  }

    depends_on = [
    helm_release.istio-base,
    helm_release.istio-discovery
  ]
}

# Reddis NoSQL DB
# https://bitnami.com/stack/redis
//helm.sh/chart=redis-14.8.3
resource "helm_release" "redis" {
  name       = "redis-release"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "14.8.3"
  namespace = kubernetes_namespace.databases.id
  # version    = "6.2.1"

  # values = [
  #   "${file("values.yaml")}"
  # ]

  set {
    name  = "architecture"
    value = "standalone"
  }

  set {
    name  = "auth.password"
    value = "fxUDbAN3pl"
  }

     set {
    name = "serviceAccount.enabled"
    value = "true"
  }

   set {
    name = "serviceAccount.automountServiceAccountToken"
    value = "true"
  }

    depends_on = [
    helm_release.istio-base,
    helm_release.istio-discovery
  ]
}