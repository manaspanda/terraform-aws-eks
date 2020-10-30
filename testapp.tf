resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}

# are you here?

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "testapp"
    namespace = kubernetes_namespace.test.metadata.0.name
    labels = {
      App = "testapp"
    }
  }


  spec {
    replicas = 5

    selector {
      match_labels = {
        App = "testapp"
      }
    }

    template {
      metadata {
        namespace = kubernetes_namespace.test.metadata.0.name
        labels = {
          App = "testapp"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "testapp"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "svc" {
  metadata {
    name      = "testapp"
    namespace = kubernetes_namespace.test.metadata.0.name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"     = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"
    }
  }
  spec {
    selector = {
      App = kubernetes_deployment.app.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "testapp_ep" {
  value = kubernetes_service.svc.load_balancer_ingress
}
