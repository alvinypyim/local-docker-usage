FROM ubuntu:focal

RUN \
  set -x && \
  sed -i \
    's/archive\.ubuntu\.com/au\.archive\.ubuntu\.com/g' \
    /etc/apt/sources.list && \
  export DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y && \
  apt-get update && \
  apt-get -y install \
    curl \
    gnupg2 \
    unzip \
    libicu66 && \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  curl \
    -L \
    -o/etc/apt/sources.list.d/msprod.list \
    https://packages.microsoft.com/config/ubuntu/20.04/prod.list && \
  apt-get update && \
  apt-get -y install mssql-tools unixodbc-dev && \
  curl \
    -L \
    -osqlpackage.zip \
    'https://go.microsoft.com/fwlink/?linkid=2143497' && \
  unzip sqlpackage.zip -d /opt/sqlpackage && \
  rm sqlpackage.zip && \
  chmod +x /opt/sqlpackage/sqlpackage
