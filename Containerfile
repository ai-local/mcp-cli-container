FROM quay.io/centos/centos:stream9

RUN dnf install -y python3.12 python3.12-pip python3-pip sudo which git npm procps-ng

# Install mcp-cli
RUN git clone https://github.com/chrishayuk/mcp-cli
WORKDIR /mcp-cli
RUN pip3.12 install -e ".[cli,dev]"

# Install ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

RUN pip install uv

# If running rootless Podman, enable the container_use_devices SELinux boolean:  sudo setsebool -P container_use_devices=true
# Build with: podman build . --tag mcp-cli --device nvidia.com/gpu=all
# Run with:   podman run --device nvidia.com/gpu=all --name mcp-cli -it mcp-cli /bin/bash
