# HashiCorp Stack on GCR
Deploy a full set of HashiStack services in Google Cloud Run starting at a few pennies a month.  Automatic HA and TLS courtesy of Google.  Couch cushion HashiStack.  This uses a single container limitation on GCR though some of them could potentially scale out if configured correctly.  Uses simple `for_each` on the variable `singletons` to simplify everything.  Note you will need to build out your own private image registry in GCR.  Dockerfiles are included.  Limitations of GCR mean you can only expose one port and it's exposed on 443.

# Dockerfiles
The Dockerfiles I use are either copied from HashiCorp official hub registry or based on CentOS Streams latest and use our signed DNF repos for secure binaries.  They could be smaller if built from a smaller Atomic distribution or custom from scratch but I'm keeping it simple and ENT friendly.

# Example:
```
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
```
Note you should not use `latest` tag obviously but I use these for release demos. Apply will happily dump out your endpoints which you can share with other workspaces in your Terraform Cloud organization:
```
Plan: 8 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + endpoints = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
```
Note that Boundary server works great but you will need an external Postgres DB for it.  The default `-dev` services are in memory only and stateless for demos which is not ideal.  If you need persistent storage you can configure the image and/or external storage directly.  For most of them you could actually use the Consul endpoint if you choose.  A great example of persistent Vault complete with KMS auto-unseal is provided by Kelsey Hightower here: https://github.com/kelseyhightower/serverless-vault-with-cloud-run

These instances are not large and not ideal for production workloads but they can be tuned and `google_cloud_run_service_iam_policy` can be customized for Google Auth.
