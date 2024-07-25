# Builder stage
FROM debian:bullseye-slim AS builder

# Set environment variables
ENV LITECOIN_VERSION=0.21.3
ENV LITECOIN_PLATFORM=aarch64-linux-gnu

# Install required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y gnupg curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Download and verify Litecoin checksum
WORKDIR /tmp
RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/davidburkett38-key.pgp && \
    gpg --import /tmp/davidburkett38-key.pgp && \
    curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz && \
    curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/SHA256SUMS.asc && \
    gpg --verify SHA256SUMS.asc && \
    grep "litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz" SHA256SUMS.asc | sha256sum -c - && \
    tar -xzf litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz -C /tmp --strip-components=1 && \
    rm /tmp/litecoin-${LITECOIN_VERSION}-${LITECOIN_PLATFORM}.tar.gz && \
    rm /tmp/davidburkett38-key.pgp && \
    rm /tmp/SHA256SUMS.asc

# Runtime stage
FROM debian:bullseye-slim AS runtime

# Install runtime dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy Litecoin binaries from the build stage
COPY --from=builder /tmp/bin /usr/local/litecoin/bin

# Set working directory
WORKDIR /opt/litecoin

# Create a non-root user and group, and set ownership
RUN addgroup --system litecoin && adduser --system --ingroup litecoin litecoin && \
chown -R litecoin:litecoin /opt/litecoin /usr/local/litecoin

# Switch to the non-root user
USER litecoin

# Expose Litecoin ports
EXPOSE 9332 9333

# Run litecoind
CMD ["/usr/local/litecoin/bin/litecoind"]
