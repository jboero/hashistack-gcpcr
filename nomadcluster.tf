module "nomad" {
  source  = "hashicorp/nomad/google"
  version = "0.1.1"
  gcp_project = var.proj
  gcp_region = var.region
  gcp_zone = "${var.region}-a"
  nomad_client_cluster_name = "nomads"
  nomad_client_source_image = ""
  nomad_consul_server_cluster_name = "nomadcluster"
  nomad_consul_server_source_image = "rhel-7-v20210420"
  nomad_client_cluster_size = 5
  nomad_client_machine_type = "g1-small"
  nomad_consul_server_cluster_size = 3
}