# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/waypoint:latest .
FROM centos:latest
RUN sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
	&& sudo dnf install -y waypoint \
	&& sudo dnf clean all

# NOTE by using this as-is you are accept the terms of service!
CMD ["/usr/bin/waypoint", "server", "run", "-accept-tos"]
