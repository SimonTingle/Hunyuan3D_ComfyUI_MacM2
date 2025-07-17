#!/bin/bash

echo "🚀 Bootstrapping Hunyuan3D-ComfyUI Project"

# Build Docker image
docker build -t hunyuan3d-comfyui -f docker/Dockerfile .

# Run interactive container
docker run --rm -it \
  -v "$(pwd)/data":/app/data \
  -v "$(pwd)/logs":/app/logs \
  -v "$(pwd)/hunyuan3d":/app/hunyuan3d \
  -v "$(pwd)/comfyui":/app/comfyui \
  hunyuan3d-comfyui /bin/bash
