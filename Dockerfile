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
  && rm tilemaker.zip
##### INSTALL GDAL #####
RUN apt-get install -y gdal-bin
RUN ogr2ogr --version
##### INSTALL TIPPECANOE #####
RUN apt-get install -y tippecanoe
##### INSTALL PMTILES #####
RUN wget -nv https://github.com/protomaps/go-pmtiles/releases/download/v1.29.1/go-pmtiles_1.29.1_Linux_x86_64.tar.gz -O pmtiles.tar.gz \
  && tar -xzf pmtiles.tar.gz pmtiles \
  && mv pmtiles /usr/local/bin/ \
  && rm pmtiles.tar.gz
##### INSTALL CONDA & MAMBA #####
ENV PATH="/root/conda/bin:${PATH}"
ARG PATH="/root/conda/bin:${PATH}"
ENV PROJ_LIB="/root/conda/share/proj"
ARG PROJ_LIB="/root/conda/share/proj"
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
##### INSTALL DUCKDB #####
RUN wget -nv https://install.duckdb.org/v1.4.1/duckdb_cli-linux-amd64.zip -O duckdb.zip \
  && echo "3e29952507ebd202e8d0e2678df4490689bfc9c86534e240b541791b969df0e1  duckdb.zip" | shasum -c \
  && unzip -p duckdb.zip duckdb > /usr/bin/duckdb \
  && chmod +x /usr/bin/duckdb \
  && rm duckdb.zip
##### INSTALL MISC TOOLS NEEDED BY USER SCRIPTS #####
RUN apt-get install -y tree time parallel gh jq

ENTRYPOINT [ "/bin/bash" ]
