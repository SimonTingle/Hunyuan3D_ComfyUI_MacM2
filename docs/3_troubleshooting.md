# 🛠 Troubleshooting

### ❌ MPS not found?
Make sure your Mac is running macOS 13+ with Python 3.10+ and PyTorch built with Metal support.

### ❌ Container doesn't start?
Try:
```bash
docker-compose down -v
docker-compose build --no-cache
```
