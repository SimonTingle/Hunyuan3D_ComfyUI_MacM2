FROM python:3.10-slim

WORKDIR /app

# Basic dependencies
RUN apt-get update && apt-get install -y git wget unzip ffmpeg  && pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu  && pip install --no-cache-dir jupyter notebook numpy trimesh open3d

# Clone Hunyuan3D
RUN git clone https://github.com/Tencent-Hunyuan/Hunyuan3D-2.1.git /app/Hunyuan3D

# Optional: Add ComfyUI for texture gen
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
