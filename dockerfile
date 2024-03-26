# Use Ubuntu as the base image
FROM ubuntu:latest

# Install necessary packages using apt-get
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    git \
    curl

# Install Rust using curl and sh
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Cargo's bin directory to the PATH environment variable
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PATH="/usr/bin/git:${PATH}"

# Set the working directory inside the container
WORKDIR /usr/src

# Copy only the necessary files into the container
COPY Cargo.toml Cargo.lock ./
COPY src ./src

# Build the dependencies (this will cache dependencies unless the Cargo.toml or Cargo.lock file changes)
RUN cargo build --release

# Set the default command to run the application
CMD ["cargo", "run", "--release", "--", "server"]