# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/boundary:latest .
FROM centos:latest
RUN sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
	&& sudo dnf install -y boundary \
	&& sudo dnf clean all

# TODO ConfigMap or ADD your config to /etc/boundary.d/controller.hcl
# TODO Postgres connection is required!
CMD ["/usr/bin/boundary", "server", "-config=/etc/boundary.d/controller.hcl"]
