# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/consul:latest .
FROM docker.io/hashicorp/consul:latest

ADD consul.d /etc/consul.d

CMD /usr/bin/consul agent -config-dir=/etc/consul.d
