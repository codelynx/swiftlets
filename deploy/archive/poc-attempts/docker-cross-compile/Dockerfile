FROM swift:6.0.2

# Install the static Linux SDK
RUN apt-get update && apt-get install -y curl

# Download and install the Swift 6.0.2 static Linux SDK
RUN curl -L https://download.swift.org/swift-6.0.2-release/static-sdk/swift-6.0.2-RELEASE/swift-6.0.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz -o sdk.tar.gz && \
    swift sdk install sdk.tar.gz && \
    rm sdk.tar.gz

# Set working directory
WORKDIR /build

# Entry point for building
ENTRYPOINT ["swift", "build", "--swift-sdk", "aarch64-swift-linux-musl", "-c", "release"]