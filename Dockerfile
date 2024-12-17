#FROM koji/image-build

# Based on RedHat Universal Base Image 7
# Reference: https://catalog.redhat.com/software/containers/ubi7/ubi/5c3592dcd70cc534b3a37814?container-tabs=gti&gti-tabs=registry-tokens
# Pulled using:
# sudo docker pull registry.redhat.io/ubi7/ubi:7.9-1445


# sudo docker login registry.redhat.io
# sudo docker pull registry.redhat.io/ubi7/ubi:7.9-1445

FROM registry.redhat.io/ubi7/ubi:7.9-1445

MAINTAINER Red Hat, Inc.

LABEL com.redhat.component="ubi7-container"
LABEL name="ubi7"
LABEL version="7.9"

LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL summary="Provides the latest release of the Red Hat Universal Base Image 7."
LABEL description="The Universal Base Image is designed and engineered to be the base layer for all of your containerized applications, middleware and utilities. This base image is freely redistributable, but Red Hat only supports Red Hat technologies through subscriptions for Red Hat products. This image is maintained by Red Hat and updated regularly."
LABEL io.k8s.display-name="Red Hat Universal Base Image 7"
LABEL io.openshift.tags="base rhel7"

ENV container oci
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["/bin/bash"]

# Install dependencies
# Added ulimit as workaround to bug that caused extremely slow file I/O
# Reference: https://stackoverflow.com/a/74346590
RUN ulimit -n 1024 && yum install -y ImageMagick

# Copy tools into container
COPY tools/runner.py /my/tools/runner.py

# Build and Run:
# docker build -t'my_ubi7_imag' .
# docker run -it my_ubi7_imag:latest /bin/bash

# Run as current user and map volume
# docker run -it -v $(pwd)/src:/dir/inside/container -u $(id -u):$(id -g)  my_ubi7_imag:latest /bin/bash

# Can also just run a specific command and get the output
# docker run -it -v $(pwd)/src:/dir/inside/container -u $(id -u):$(id -g) my_ubi7_image python /my/tools/runner.py -f FOO -b BAR
# {'foo': 'FOO', 'bar': 'BAR'}