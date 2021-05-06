# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/vault:latest .
FROM docker.io/hashicorp/vault:latest

CMD ["/usr/bin/vault", "server", "-dev", "-dev-listen-address=:8200"]
