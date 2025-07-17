#!/bin/bash

# Define project root
PROJECT_ROOT="/Users/simontingle/Desktop/WORK/PROGRAMMING/TEST_PROJECTS/Hunyuan3D_ComfyUI_Mac"
mkdir -p "$PROJECT_ROOT"
cd "$PROJECT_ROOT" || exit 1

echo "🔧 Creating directory structure..."

# Create main folders
mkdir -p docker
mkdir -p scripts
mkdir -p hunyuan3d
mkdir -p comfyui
mkdir -p data/{input_models,output_textures}
mkdir -p assets
mkdir -p notebooks
mkdir -p logs
mkdir -p config
mkdir -p docs/pages

# README (multi-page)
touch README.md
touch docs/pages/01_Overview.md
touch docs/pages/02_Setup.md
touch docs/pages/03_Docker.md
touch docs/pages/04_Texture_Generation.md
touch docs/pages/05_Advanced_Usage.md

# Dockerfile
cat <<EOF > docker/Dockerfile
# Base Dockerfile for Hunyuan3D + ComfyUI
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# System deps
RUN apt-get update && apt-get install -y \\
    git python3 python3-pip ffmpeg curl libgl1 unzip

# Python env
COPY requirements.txt /tmp/
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Add model + UI source
COPY hunyuan3d /app/hunyuan3d
COPY comfyui /app/comfyui

WORKDIR /app
CMD ["/bin/bash"]
EOF

# requirements.txt
cat <<EOF > requirements.txt
torch==2.1.2
torchvision
opencv-python
transformers
numpy
Pillow
matplotlib
tqdm
gradio
EOF

# Example ComfyUI and Hunyuan3D placeholders
touch comfyui/__init__.py
touch hunyuan3d/__init__.py

# Bootstrap script
cat <<EOF > scripts/bootstrap.sh
#!/bin/bash

echo "🚀 Bootstrapping Hunyuan3D-ComfyUI Project"

# Build Docker image
docker build -t hunyuan3d-comfyui -f docker/Dockerfile .

# Run interactive container
docker run --rm -it \\
  -v "\$(pwd)/data":/app/data \\
  -v "\$(pwd)/logs":/app/logs \\
  -v "\$(pwd)/hunyuan3d":/app/hunyuan3d \\
  -v "\$(pwd)/comfyui":/app/comfyui \\
  hunyuan3d-comfyui /bin/bash
EOF

chmod +x scripts/bootstrap.sh

# .gitignore
cat <<EOF > .gitignore
__pycache__/
*.pyc
*.log
*.DS_Store
*.ckpt
*.pth
data/output_textures/
logs/
.env
EOF

# LICENSE (MIT)
cat <<EOF > LICENSE
MIT License

Copyright (c) 2025 Simon Tingle

Permission is hereby granted, free of charge, to any person obtaining a copy...
EOF

echo "✅ Project structure ready at: $PROJECT_ROOT"