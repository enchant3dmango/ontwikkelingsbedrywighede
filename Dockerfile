# Use an official Ubuntu as a base image
FROM ubuntu:20.04

# Set environment variables
ENV LITECOIN_VERSION=0.21.3
ENV LITECOIN_PLATFORM=x86_64-linux-gnu

# Install required packages to download Litecoin
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y gnupg curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Set a temporary working directory
WORKDIR /tmp

# Download and import the public key file
RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/davidburkett38-key.pgp && \
    gpg --import /tmp/davidburkett38-key.pgp

# Download Litecoin and verify checksum
RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz && \
    curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/SHA256SUMS.asc && \
    gpg --verify SHA256SUMS.asc && \
    grep "litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz" SHA256SUMS.asc | sha256sum -c -

# Extract files and clean up
RUN tar -xzf litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz -C /usr/local --strip-components=1 && \
    rm litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz

# Set the final working directory
WORKDIR /opt/litecoin

# Expose Litecoin ports
EXPOSE 9332 9333

# Run litecoind
CMD ["/opt/litecoind"]
