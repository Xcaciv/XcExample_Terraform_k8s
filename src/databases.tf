
# PostgreSQL helm chart from bitnami
# https://bitnami.com/stack/postgresql/helm

resource "helm_release" "postgres" {
  chart = "bitnami/postgresql"
  name = "my-app-postgres"
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

    depends_on = [
    helm_release.istio-base,
    helm_release.istio-discovery
  ]
}

# Reddis NoSQL DB
# https://bitnami.com/stack/redis

resource "helm_release" "redis" {
  name       = "redis-release"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
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

    depends_on = [
    helm_release.istio-base,
    helm_release.istio-discovery
  ]
}