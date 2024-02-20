FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel
WORKDIR /workspace

RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list
# python, dependencies for mujoco-py, from https://github.com/openai/mujoco-py
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3-pip \
    build-essential \
    patchelf \
    curl \
    git \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    software-properties-common \
    libx11-dev \ 
    libxcursor-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxi-dev \
    net-tools \
    vim \
    virtualenv \
    wget \
    xpra \
    xserver-xorg-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y sudo

# RUN ln -s /usr/bin/python3 /usr/bin/python
# installing mujoco distr
RUN mkdir -p /root/.mujoco \
     && wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz -O mujoco.tar.gz \
     && tar -xf mujoco.tar.gz -C /root/.mujoco \
     && rm mujoco.tar.gz
ENV LD_LIBRARY_PATH /root/.mujoco/mujoco210/bin:${LD_LIBRARY_PATH}

# installing dependencies, optional mujoco_py compilation
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

RUN git clone https://github.com/openai/mujoco-py /root/.mujoco/mujoco-py \
     && cd /root/.mujoco/mujoco-py \
     && pip install -r requirements.txt \
     && pip install -r requirements.dev.txt \
     && pip3 install -e . --no-cache
RUN pip install chex==0.1.6
RUN pip install pygame
RUN pip install dotmap
RUN pip install agents     
RUN pip install -U 'mujoco-py<2.2,>=2.1'
RUN pip install 'cython<3'
RUN python -c "import mujoco_py"
