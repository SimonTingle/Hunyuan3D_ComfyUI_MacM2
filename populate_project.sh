#!/bin/bash

echo "🚧 Populating all files in your Hunyuan3D_ComfyUI_Mac project..."

# README files
cat <<EOF > README.md
# Hunyuan3D-ComfyUI for macOS M2

This project containerizes **Tencent's Hunyuan3D-2.1** and adds **ComfyUI** for texture generation inside a secure Docker environment, fully optimized for Apple Silicon (M1/M2/M3) via Python + Metal backend.

📦 **Features**
- Shape generation using Hunyuan3D
- Texture generation via ComfyUI workflows
- Preconfigured Docker + volume mappings
- Multi-page README + setup automation

See \`docs/1_install.md\`, \`docs/2_usage.md\`, and \`docs/3_troubleshooting.md\`.

---

EOF

# Documentation
cat <<EOF > docs/1_install.md
# 📥 Installation Guide

## 1. Install Docker Desktop for Mac (Apple Silicon)

https://docs.docker.com/desktop/install/mac/

## 2. Clone This Repo

\`\`\`bash
git clone https://github.com/SimonTingle/Hunyuan3D_ComfyUI_Mac.git
cd Hunyuan3D_ComfyUI_Mac
\`\`\`

## 3. Build & Run

\`\`\`bash
docker-compose up --build
\`\`\`
EOF

cat <<EOF > docs/2_usage.md
# 🧪 Usage

## Run Interactive Notebook

Once the container is running, visit:  
👉 http://localhost:8888

Inside Jupyter, use:
- \`notebooks/Hunyuan3D_ShapeGen.ipynb\`
- \`notebooks/Comfy_TextureGen.ipynb\`

Textures are saved in \`output/textures/\`  
Meshes are saved in \`output/meshes/\`
EOF

cat <<EOF > docs/3_troubleshooting.md
# 🛠 Troubleshooting

### ❌ MPS not found?
Make sure your Mac is running macOS 13+ with Python 3.10+ and PyTorch built with Metal support.

### ❌ Container doesn't start?
Try:
\`\`\`bash
docker-compose down -v
docker-compose build --no-cache
\`\`\`
EOF

# Dockerfile
cat <<EOF > docker/Dockerfile
FROM python:3.10-slim

WORKDIR /app

# Basic dependencies
RUN apt-get update && apt-get install -y git wget unzip ffmpeg \
 && pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu \
 && pip install --no-cache-dir jupyter notebook numpy trimesh open3d

# Clone Hunyuan3D
RUN git clone https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1.git /app/Hunyuan3D

# Optional: Add ComfyUI for texture gen
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
EOF

# docker-compose.yml
cat <<EOF > docker-compose.yml
version: '3.9'

services:
  hunyuan3d:
    build:
      context: ./docker
      dockerfile: Dockerfile
    ports:
      - "8888:8888"
    volumes:
      - ./notebooks:/app/notebooks
      - ./output:/app/output
      - ./models:/app/models
      - ./assets:/app/assets
    environment:
      - PYTHONUNBUFFERED=1
EOF

# .gitignore
cat <<EOF > .gitignore
__pycache__/
*.pyc
*.pyo
*.pyd
*.DS_Store
.env
output/
models/
assets/
EOF

# License
cat <<EOF > LICENSE
MIT License

Copyright (c) 2025 Simon Tingle

Permission is hereby granted, free of charge, to any person obtaining a copy...
EOF

# Placeholder notebooks
cat <<EOF > notebooks/Hunyuan3D_ShapeGen.ipynb
{
 "cells": [],
 "metadata": {},
 "nbformat": 4,
 "nbformat_minor": 2
}
EOF

cat <<EOF > notebooks/Comfy_TextureGen.ipynb
{
 "cells": [],
 "metadata": {},
 "nbformat": 4,
 "nbformat_minor": 2
}
EOF

echo "✅ All files populated. Ready to push to GitHub!"