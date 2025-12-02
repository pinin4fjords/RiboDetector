# RiboDetector CPU Docker Image
# Accurate and rapid RiboRNA sequences Detector based on deep learning

FROM python:3.10

LABEL org.opencontainers.image.title="RiboDetector"
LABEL org.opencontainers.image.description="Accurate and rapid RiboRNA sequences Detector based on deep learning"
LABEL org.opencontainers.image.source="https://github.com/hzi-bifo/RiboDetector"
LABEL org.opencontainers.image.licenses="GPL-3.0"

# Install system dependencies (execstack needed for onnxruntime)
RUN apt-get update && apt-get install -y --no-install-recommends \
    procps \
    execstack \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files
COPY setup.py README.md ./
COPY ribodetector/ ./ribodetector/

# Install the package
RUN pip install --no-cache-dir . \
    && execstack -c /usr/local/lib/python3.10/site-packages/onnxruntime/capi/*.so

# Create a non-root user for running the application
RUN useradd -m -u 1000 ribodetector
USER ribodetector

# Set the entrypoint to the CPU version
ENTRYPOINT ["ribodetector_cpu"]
