provider "google" {
  project     = "gb-playground"
  region      = "eu-west4"
}

resource "google_cloud_run_service" "nomadCR" {
  name     = "nomadCR"
  location = var.location

  template {
    spec {
      containers {
        image = "gcr.io/gb-playground/nomad:1.0.4"
        command = ["/usr/bin/nomad", "agent", "-dev"]
        ports {
            name = "nomad"
            container_port = 4646
        }
        ports {
            name = "cluster"
            container_port = 4647
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_cloud_run_service" "consulCR" {
  name     = "consulCR"
  location = var.location

  template {
    spec {
      containers {
        image = "docker.io/hashicorp/consul:latest"
        command = ["/usr/bin/consul", "agent", "-dev"]
        ports {
            name = "consul"
            container_port = 8500
        }
        ports {
            name = "dns"
            container_port = 8600
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  autogenerate_revision_name = true
}

resource "google_cloud_run_service" "vaultCR" {
  name     = "vaultCR"
  location = var.location

  template {
    spec {
      containers {
        image = "docker.io/hashicorp/vault:latest"
        command = ["/usr/bin/vault", "agent", "-dev"]
        ports {
            name = "vault"
            container_port = 8200
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  autogenerate_revision_name = true
}