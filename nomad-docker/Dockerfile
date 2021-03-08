# Don't forget OCI issues...
# podman build --format docker -t gcr.io/gb-playground/nomad:latest .
FROM centos:latest
MAINTAINER John Boero <boeroboy@gmail.com>
RUN yum -y install unzip \
	&& yum clean all \
	&& curl -o nomad.zip https://releases.hashicorp.com/nomad/1.0.4/nomad_1.0.4_linux_amd64.zip \
	&& unzip nomad.zip -d /usr/bin/
CMD ["/usr/bin/nomad", "agent", "-server", "-dev"]
