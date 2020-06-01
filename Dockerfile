FROM ubuntu:latest

# Install dependencies
RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  gcc \
  sudo \
  build-essential \
  libgtk-3-dev \
  python3 \
  python3-pip \
  python3-setuptools \
  python3-serial \
  wget \
  flex \
  bison \
  cmake \
  ninja-build \
  gperf \
  libncurses5-dev

# Link python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install Moddable
ENV MODDABLE /root/moddable
WORKDIR /root
RUN git clone https://github.com/Moddable-OpenSource/moddable.git
WORKDIR /root/moddable/build/makefiles/lin
RUN make
ENV PATH $PATH:${MODDABLE}/build/bin/lin/release
RUN make install

# Install ESP-IDF
ENV IDF_PATH /root/esp32/esp-idf
RUN mkdir /root/esp32 
WORKDIR /root/esp32
RUN git clone -b v3.3.2 --recursive https://github.com/espressif/esp-idf.git
RUN python -m pip install --user -r $IDF_PATH/docs/requirements.txt
ENV PATH $PATH:~/esp32/xtensa-esp32-elf/bin:$IDF_PATH/tools

# Xtensa toolchain
ENV PATH $PATH:/root/esp32/xtensa-esp32-elf/bin
WORKDIR /root/esp32
RUN wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz && \
    tar xvzf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

# Build Folder
RUN mkdir /source
VOLUME ["/source"]

WORKDIR /source

ENTRYPOINT ["mcconfig"]
