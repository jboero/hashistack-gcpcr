# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/consul:latest .
FROM centos:latest
RUN sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo \
	&& sudo dnf install -y consul \
	&& sudo dnf clean all

# TODO: ConfigMap or ADD your config to /etc/consul.d/
CMD /usr/bin/consul agent -config-dir=/etc/consul.d
