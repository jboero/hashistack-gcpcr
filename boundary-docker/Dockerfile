# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/boundary:latest .
FROM docker.io/hashicorp/boundary:latest

# TODO ConfigMap or ADD your config to /etc/boundary.d/controller.hcl
ADD boundary.d /etc/boundary.d

# TODO Postgres connection is required!
CMD ["/usr/bin/boundary", "server", "-config=/etc/boundary.d/controller.hcl"]
