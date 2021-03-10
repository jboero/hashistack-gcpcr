# Don't forget OCI issues...
# podman build --format docker -t gcr.io/gb-playground/nomad:latest .
FROM ubuntu:18.04
MAINTAINER John Boero <boeroboy@gmail.com>
ADD consul /usr/bin/
ADD consul.d /etc/consul.d/
#CMD env
#CMD /usr/bin/consul agent -dev -bind='{{ GetAllInterfaces | attr "address" }}'
#CMD /usr/bin/consul agent -server -bootstrap-expect=1 -data-dir=/tmp -ui -bind=0.0.0.0 -advertise=127.0.0.1
CMD /usr/bin/consul agent -config-dir=/etc/consul.d
