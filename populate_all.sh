#!/bin/bash

set -e

echo "🚀 Setting up full project structure for Hunyuan3D-2.1 on Mac M2 using Docker + ComfyUI..."

# Set root
ROOT_DIR=Hunyuan3D_ComfyUI_Mac
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# === Project Directory Tree ===
mkdir -p \
  assets/input \
  assets/output \
  models/checkpoints \
  custom_nodes \
  docker \
  scripts

# === Clone Repos ===
echo "📦 Cloning ComfyUI and custom Hunyuan3D nodes..."
git clone https://github.com/comfyanonymous/ComfyUI.git app
git clone https://github.com/niknah/ComfyUI-Hunyuan-3D-2.git app/custom_nodes/ComfyUI-Hunyuan-3D-2

# === Write Dockerfile ===
cat > docker/Dockerfile << 'EOF'
FROM --platform=linux/arm64 ubuntu:22.04

RUN apt-get update && apt-get install -y \
    git python3 python3-pip wget build-essential ffmpeg

WORKDIR /workspace

COPY app /workspace/app

# Install MPS-compatible PyTorch
RUN pip3 install --pre torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/cpu

# Install ComfyUI and Hunyuan3D node dependencies
RUN pip3 install -r app/requirements.txt
RUN pip3 install -r app/custom_nodes/ComfyUI-Hunyuan-3D-2/requirements.txt

# Download pretrained models
RUN mkdir -p /workspace/models/checkpoints && \
    wget https://huggingface.co/Tencent-Hunyuan/Hunyuan3D-DiT-v2-1/resolve/main/model.ckpt -O /workspace/models/checkpoints/Hunyuan3D-DiT.ckpt && \
    wget https://huggingface.co/Tencent-Hunyuan/Hunyuan3D-Paint-v2-1/resolve/main/model.ckpt -O /workspace/models/checkpoints/Hunyuan3D-Paint.ckpt && \
    wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -P /workspace/app/custom_nodes/ComfyUI-Hunyuan-3D-2/ckpt

EXPOSE 8188

CMD ["python3", "app/main.py", "--listen", "0.0.0.0", "--port", "8188"]
EOF

# === Write Bootstrap Script ===
cat > scripts/bootstrap.sh << 'EOF'
#!/bin/bash

cd "$(dirname "$0")/.."

echo "🔨 Building Docker image..."
docker build -t hunyuan3d-mac -f docker/Dockerfile .

echo "🚪 Running Docker container (ComfyUI)..."
docker run --platform linux/arm64 -it \
  -p 8188:8188 \
  -v "$(pwd)/assets":/workspace/assets \
  -v "$(pwd)/models":/workspace/models \
  --name hunyuan3d-comfyui \
  hunyuan3d-mac
EOF

chmod +x scripts/bootstrap.sh

# === README ===
cat > README.md << 'EOF'
# 🧠 Hunyuan3D‑2.1 Docker (Mac M2 Edition)

Generate full 3D shape + textured models using Tencent's Hunyuan3D‑2.1 via ComfyUI, all inside Docker and Apple M2-compatible.

## 🚀 Usage

1. Place your 2D input image in `assets/input/image.png`
2. Run the bootstrap script:

```bash
./scripts/bootstrap.sh