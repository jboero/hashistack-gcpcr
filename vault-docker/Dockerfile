# Don't forget OCI issues...
# podman build --format docker -t gcr.io/gb-playground/nomad:latest .
FROM centos:latest
MAINTAINER John Boero <boeroboy@gmail.com>
RUN yum -y install unzip \
	&& yum clean all \
	&& curl -o vault.zip https://releases.hashicorp.com/vault/1.6.3/vault_1.6.3_linux_amd64.zip \
	&& unzip vault.zip -d /usr/bin/
CMD ["/usr/bin/vault", "server", "-dev", "-dev-listen-address=0.0.0.0:8200"]
