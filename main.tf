/************  John Boero - jboero@hashicorp.com
 This sample uses a map variable and a for_each to deploy your container images
 as Google Cloud Run singletons (limit 1 container).  TLS is provided.
 You must customize your own image and build it into your own image registry.*/
variable "proj" {
    description = "GCP Project ID."
    default = "gb-playground"
}

variable "location" {
    description = "GCP Region to deploy cloud run services - ie europe-west4."
    default = "europe-west4"
}

// Set this to a map of your container images and which primary port they use.
// Since it's a map you can add extra attributes if you need to.
variable "singletons" {
  description = "Map of containers and ports to deploy in GCR."
  default = {
    vault = {
      name    = "vault:latest"
      command = ["/bin/vault", "server", "-dev", "-dev-listen-address=:8200"]
      port    = 8200
    },
    consul = {
      name  = "consul:latest"
      command = ["/bin/consul", "agent", "-config-dir=/etc/consul.d"]
      port = 8500
    },
    nomad = {
      name  = "nomad:latest"
      command = ["/usr/bin/nomad", "agent", "-dev", "-bind", "0.0.0.0"]
      port = 4646
    },
    waypoint = {
      name  = "waypoint:latest"
      command = ["/usr/bin/waypoint", "server", "run", "-accept-tos", "-listen-http=0.0.0.0:9702", "-db=/tmp/tmp.db"]
      port = 9702
    },/*
    boundary = { // Boundary requires an external Postgres db.
      name  = "boundary:latest"
      command = ["/bin/boundary", "server", "-config=/etc/boundary.d/controller.hcl"]
      port = 9200
    }*/
  }
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

// Use a for_each on var.singletons
resource "google_cloud_run_service" "runners" {
  for_each = var.singletons
  name     = "${each.key}-gcr"
  location = var.location
  project  = var.proj
  
  template {
    spec {
      containers {
        image = "gcr.io/${var.proj}/${each.value.name}"
        command = [each.value.command[0]]
        args = slice(each.value.command, 1, length(each.value.command))
        ports {
            name = "http1"
            container_port = each.value.port
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "1"
        "autoscaling.knative.dev/minScale"      = "1"
        "run.googleapis.com/client-name"        = each.key
      }
    }
  }
}

// This is ugly in prod but for demos open up noauth access to outsiders.
resource "google_cloud_run_service_iam_policy" "noauths" {
  for_each    = google_cloud_run_service.runners
  location    = var.location
  project     = var.proj
  service     = each.value.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

// Output all of our endpoints to people can consume them in other workspaces.
output "endpoints" {
  value = toset([for u in google_cloud_run_service.runners : u.status[0].url])
}