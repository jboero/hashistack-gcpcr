# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/vault:latest .
FROM centos:latest
RUN sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
	&& sudo dnf install -y vault \
	&& sudo dnf clean all

CMD ["/usr/bin/vault", "server", "-dev", "-dev-listen-address=:8200"]
