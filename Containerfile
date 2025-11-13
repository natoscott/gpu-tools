# Start from NVIDIA CUDA UBI9 image
FROM nvcr.io/nvidia/cuda:12.9.1-devel-ubi9

# Set work directory
WORKDIR /root
RUN mkdir /root/rpms
COPY ./rpms/*.rpm /root/rpms/

# DNF install packages either from repo or locally
RUN dnf install -y wget procps-ng pciutils jq iputils ethtool net-tools git autoconf automake libtool diffutils
RUN dnf install -y infiniband-diags rdma-core-devel libibumad librdmacm libxcb libxcb-devel libxkbcommon
# Install architecture-specific RPMs
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        dnf install -y /root/rpms/*.x86_64.rpm; \
    elif [ "$ARCH" = "aarch64" ]; then \
        dnf install -y /root/rpms/*.aarch64.rpm; \
    fi

# Cleanup 
WORKDIR /root
RUN dnf clean all

# Run container entrypoint
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
