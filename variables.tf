variable "proj" {
    description = "GCP Project ID."
    default = "gb-playground"
}

variable "region" {
    description = "GCP Region to deploy cloud run services - ie europe-west4."
    default = "europe-west4"
}

variable "boundarydbpass" {
    description = "Boundary database user password."
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
    }/*,
    waypoint = { // Waypoint forces TLS unfortunately which breaks GCR.
      name  = "waypoint:latest"
      command = ["/usr/bin/waypoint", "server", "run", "-accept-tos", 
        "-url-api-insecure", "-listen-http=0.0.0.0:9702",  "-db=/tmp/tmp.db"]
      port = 9702
    },
    boundary = { // Boundary requires an external Postgres db.
      name  = "boundary:latest"
      command = ["/bin/boundary", "server", "-config=/etc/boundary.d/controller.hcl"]
      port = 9200
    }*/
  }
}
