# Don't forget OCI issues...
# podman build --format docker -t gcr.io/{PROJECT}/waypoint:latest .
FROM docker.io/hashicorp/waypoint:latest

ADD tmp.db /tmp/tmp.db
# NOTE by using this as-is you are accept the terms of service!
CMD ["/usr/bin/waypoint", "server", "run", "-accept-tos"]
