FROM debian:trixie-slim
RUN echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/backports.list
RUN apt-get update
# Misc system tools needed for image build
RUN apt-get install -y wget gpg unzip curl git
##### INSTALL TILEMAKER #####
# RUN apt-get install -y zlib1g-dev libboost-iostreams-dev build-essential libboost-dev libboost-filesystem-dev libboost-program-options-dev libboost-system-dev lua5.1 liblua5.1-0-dev libshp-dev libsqlite3-dev rapidjson-dev \
#   && git clone --depth 1 --branch v3.0.0 https://github.com/systemed/tilemaker.git \
#   && cd tilemaker \
#   && make \
#   && make install \
#   && cd .. \
#   && rm -rf tilemaker
RUN wget -nv https://github.com/systemed/tilemaker/releases/download/v3.0.0/tilemaker-ubuntu-22.04.zip -O tilemaker.zip \
  && unzip -p tilemaker.zip build/tilemaker > /usr/bin/tilemaker \
  && chmod +x /usr/bin/tilemaker \
  && rm tilemaker
##### INSTALL GDAL #####
RUN apt-get install -y gdal-bin
RUN ogr2ogr --version
##### INSTALL TIPPECANOE #####
RUN apt-get install -y tippecanoe
##### INSTALL PMTILES #####
RUN wget -nv https://github.com/protomaps/go-pmtiles/releases/download/v1.28.0/go-pmtiles_1.28.0_Linux_arm64.tar.gz -O pmtiles.tar.gz \
  && tar -xzf pmtiles.tar.gz pmtiles \
  && mv pmtiles /usr/local/bin/ \
  && rm pmtiles.tar.gz
##### INSTALL CONDA & MAMBA #####
ENV PATH="/root/conda/bin:${PATH}"
ARG PATH="/root/conda/bin:${PATH}"
RUN wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
  && bash Miniforge3.sh -b -p "/root/conda"
##### INSTALL DVC #####
RUN mamba install -c conda-forge dvc \
  && mamba install -c conda-forge dvc-s3
##### INSTALL GDAL PARQUET DRIVER #####
RUN mamba install -c conda-forge libgdal-arrow-parquet
##### INSTALL NODE & NPM #####
RUN apt-get install -y nodejs npm
##### INSTALL AWS CLI #####
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm awscliv2.zip \
  && rm -rf ./aws
##### INSTALL MISC TOOLS NEEDED BY USER SCRIPTS #####
RUN apt-get install -y tree time parallel

ENTRYPOINT [ "/bin/bash" ]
