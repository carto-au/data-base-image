FROM linuxcontainers/debian-slim:12.5
RUN echo 'deb http://deb.debian.org/debian bookworm-backports main' > /etc/apt/sources.list.d/backports.list
RUN apt-get update
# Misc system tools
RUN apt-get install -y wget gpg unzip tree
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

ENTRYPOINT [ "/bin/bash" ]
