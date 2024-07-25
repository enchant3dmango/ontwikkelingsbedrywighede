# Learning references (https://docs.docker.com/build/building/best-practices/, https://security.stackexchange.com/questions/1687/)
# Builder stage
FROM ubuntu:20.04 AS builder

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

# Download and extract Litecoin and verify checksum
RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz && \
    curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/SHA256SUMS.asc && \
    gpg --verify SHA256SUMS.asc && \
    grep "litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz" SHA256SUMS.asc | sha256sum -c - && \
    tar -xzf litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz -C /tmp --strip-components=1 && \
    ls -a /tmp && \
    rm /tmp/litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz

# Runtime stage
FROM alpine:3.20.2 AS runtime

# Install runtime dependencies
RUN apk add --no-cache ca-certificates

# Copy Litecoin binaries from the build stage
COPY --from=builder /tmp/bin /usr/local/litecoin/bin

# Set the final working directory
WORKDIR /opt/litecoin

# Expose Litecoin ports (https://www.speedguide.net/port.php?port=9333)
EXPOSE 9332 9333

# Run litecoind
CMD ["/usr/local/bin/litecoind"]
