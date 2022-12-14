ARG CUDA_VERSION=11.4.2
ARG CUDNN_VERSION=8
ARG IMGTYPE=runtime
ARG OS=ubuntu20.04
FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-${IMGTYPE}-${OS}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    git gcc python3 python3-pip python3.8 libpython3.8-dev zlib1g-dev libjpeg62-dev curl ca-certificates tree \
    libglib2.0-0 libsm6 libice6 libxrender1 libxext6 libx11-6 libgl1-mesa-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
RUN cd $(dirname $(which python3.8)) && rm python3 && ln -s python3.8 python3

COPY requirements.txt /requirements.txt
RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip --no-cache-dir install -r ./requirements.txt
RUN pip install torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
# Use Agg backend for matplotlib
ENV DISPLAY 0
