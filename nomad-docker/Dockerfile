# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/nomad:latest .
FROM centos:latest
RUN sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
	&& sudo dnf install -y nomad \
	&& sudo dnf clean all
	
CMD ["/usr/bin/nomad", "agent", "-dev", "-bind=0.0.0.0"]
