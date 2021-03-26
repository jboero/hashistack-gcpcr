variable "proj" {
    description = "GCP Project ID."
    default = "gb-playground"
}

variable "location" {
    description = "GCP Region to deploy cloud run services - ie eu-west4."
    default = "europe-west4"
}

provider "google" {
  project = var.proj
  region  = var.location
  zone    = "${var.location}-a"
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service" "nomad-gcr" {
  name     = "nomad-gcr"
  location = var.location
  project  = var.proj
  
  template {
    spec {
      containers {
        image = "gcr.io/${var.proj}/nomad:1.0.4"
        command = ["/usr/bin/nomad", "agent", "-dev"]
        ports {
            name = "http1"
            container_port = 4646
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1"
        "autoscaling.knative.dev/minScale"      = "1"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
    
  }
  //autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_policy" "noauth-nomad" {
  location    = var.location
  project     = var.proj
  service     = google_cloud_run_service.nomad-gcr.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_service" "vault-gcr" {
  name     = "vault-gcr"
  location = var.location
  project  = var.proj
  
  template {
    spec {
      containers {
        image = "gcr.io/${var.proj}/vault:1.6.3"
        command = ["/usr/bin/vault", "server", "-dev", "-dev-root-token-id=${var.vault_root_token}"]
        ports {
            name = "http1"
            container_port = 8200
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1"
        "autoscaling.knative.dev/minScale"      = "1"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
}

resource "google_cloud_run_service_iam_policy" "noauth-vault" {
  location    = var.location
  project     = var.proj
  service     = google_cloud_run_service.vault-gcr.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_service" "consul-gcr" {
  name     = "consul-gcr"
  location = var.location
  project  = var.proj
  
  template {
    spec {
      containers {
        image = "gcr.io/${var.proj}/consul:1.9.4"
        ports {
            name = "http1"
            container_port = 8500
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1"
        "autoscaling.knative.dev/minScale"      = "1"
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
}

resource "google_cloud_run_service_iam_policy" "noauth-consul" {
  location    = var.location
  project     = var.proj
  service     = google_cloud_run_service.consul-gcr.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

output "endpoint-consul" {
  value = google_cloud_run_service.consul-gcr.status[0].url
}

output "endpoint-nomad" {
  value = google_cloud_run_service.nomad-gcr.status[0].url
}

output "endpoint-vault" {
  value = google_cloud_run_service.vault-gcr.status[0].url
}
