# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/nomad:latest .
FROM centos:latest
RUN dnf install -y dnf-plugins-core \
	&& dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
	&& dnf install -y nomad \
	&& dnf clean all
	
CMD ["/usr/bin/nomad", "agent", "-dev", "-bind=0.0.0.0"]
