# CosyVoice3 Docker

CosyVoice 3.0 TTS 服务 Docker 镜像，用于数字人直播。

## 快速开始

### 1. 拉取镜像

```bash
docker pull junpeng999/cosyvoice3:latest
```

### 2. 下载模型

```bash
mkdir -p ~/cosyvoice-models

# 使用 HuggingFace
pip install huggingface_hub
python -c "
from huggingface_hub import snapshot_download
snapshot_download('FunAudioLLM/Fun-CosyVoice3-0.5B-2512', local_dir='~/cosyvoice-models/Fun-CosyVoice3-0.5B')
"
```

### 3. 运行容器

```bash
docker run -d --gpus all \
  --name cosyvoice3 \
  --network host \
  -v ~/cosyvoice-models:/app/CosyVoice/pretrained_models \
  junpeng999/cosyvoice3:latest \
  tail -f /dev/null
```

### 4. 进入容器

```bash
docker exec -it cosyvoice3 bash
```

## 功能

- CosyVoice 3.0 TTS
- 零样本语音克隆
- 流式推理
- RTP 音频推流

## 端口

- 8000: API 服务
- 5004/udp: RTP 音频流
