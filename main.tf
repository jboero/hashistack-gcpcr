/************  John Boero - jboero@hashicorp.com
 This sample uses a map variable and a for_each to deploy your container images
 as Google Cloud Run singletons (limit 1 container).  TLS is provided.
 You must customize your own image and build it into your own image registry.*/

provider "google" {
  project = var.proj
  region  = var.region
  zone    = "${var.region}-a"
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
  location = var.region
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
  location    = var.region
  project     = var.proj
  service     = each.value.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

// Output all of our endpoints to people can consume them in other workspaces.
output "endpoints" {
  value = toset([for u in google_cloud_run_service.runners : u.status[0].url])
}
