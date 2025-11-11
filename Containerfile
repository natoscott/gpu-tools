# Start from UBI9 image
FROM registry.access.redhat.com/ubi9/ubi:latest

# Set work directory
WORKDIR /root
RUN mkdir /root/rpms
COPY ./rpms/*.rpm /root/rpms/

# DNF install packages either from repo or locally
RUN dnf install -y wget procps-ng pciutils jq iputils ethtool net-tools git autoconf automake libtool diffutils
RUN dnf install -y infiniband-diags rdma-core-devel libibumad librdmacm libxcb libxcb-devel libxkbcommon
RUN dnf install -y `ls -1 /root/rpms/*.aarch64.rpm` -y

# Cleanup 
WORKDIR /root
RUN dnf clean all

# Run container entrypoint
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
