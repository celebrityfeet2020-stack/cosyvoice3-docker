FROM pytorch/pytorch:2.5.0-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    wget \
    sox \
    libsox-dev \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 克隆 CosyVoice 仓库
RUN git clone --recursive https://github.com/FunAudioLLM/CosyVoice.git /app/CosyVoice

WORKDIR /app/CosyVoice

# 初始化子模块
RUN git submodule update --init --recursive

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 安装额外依赖（RTP推流、API服务）
RUN pip install --no-cache-dir fastapi uvicorn python-multipart

# 模型目录（运行时挂载）
VOLUME /app/CosyVoice/pretrained_models

# 暴露端口
EXPOSE 8000
EXPOSE 5004/udp

CMD ["bash"]
