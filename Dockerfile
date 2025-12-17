FROM pytorch/pytorch:2.5.0-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# 安装系统依赖（包括编译工具）
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    sox \
    libsox-dev \
    libsox-fmt-all \
    ffmpeg \
    build-essential \
    cmake \
    pkg-config \
    libsndfile1 \
    libsndfile1-dev \
    && rm -rf /var/lib/apt/lists/*

# 克隆 CosyVoice 仓库
RUN git clone --recursive https://github.com/FunAudioLLM/CosyVoice.git /app/CosyVoice

WORKDIR /app/CosyVoice

# 初始化子模块
RUN git submodule update --init --recursive

# 先升级 pip
RUN pip install --upgrade pip setuptools wheel

# 安装 Python 依赖（分步安装，便于调试）
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cu124 || true
RUN pip install --no-cache-dir -r requirements.txt || \
    (cat requirements.txt && pip install --no-cache-dir $(grep -v "^#" requirements.txt | grep -v "torch" | tr '\n' ' '))

# 安装额外依赖（RTP推流、API服务）
RUN pip install --no-cache-dir fastapi uvicorn python-multipart

# 模型目录（运行时挂载）
VOLUME /app/CosyVoice/pretrained_models

# 暴露端口
EXPOSE 8000
EXPOSE 5004/udp

CMD ["bash"]
