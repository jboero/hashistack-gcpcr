# Don't forget OCI issues...
# podman build --format docker -t gcr.io/gb-playground/nomad:latest .
FROM centos:latest
MAINTAINER John Boero <boeroboy@gmail.com>
ADD consul /usr/bin/
ADD consul.d /etc/consul.d/

CMD /usr/bin/consul agent -config-dir=/etc/consul.d
