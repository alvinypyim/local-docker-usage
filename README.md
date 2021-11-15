# Local Docker Usage

This list summarises how I use Docker locally for short-living tasks..

1. Set up a database locally for my development work; they are usually reset
   around every fortnight.

   ```
   mssql:
     image: mcr.microsoft.com/mssql/server:2017-latest 
     ports:
     - 1433:1433
     environment:
       SA_PASSWORD: '\SFZge/wzd{V86`u1T>ZDUMMY'
       ACCEPT_EULA: Y
   ```

   Then,

   ```
   docker-compose up -d
   ```

   Then I can connect to the server through the "bridge" IP usually
   `10.0.2.15`; and in SQL Server's case `10.0.2.15:1433` or more specifically
   `10.0.2.15,1433`.  I don't use the "linking" function provided by
   Docker/`docker-compose` because it has too much limitationl one bad one
   being forcing us to delete linked service when we want to keep it.

   Before I turn off my machine,

   ```
   docker-compose stop
   ```

1. Do some experimental work in Ubuntu/Alpine; they are removed instantly after
   the job is done, probably within minutes after creation.

   ```
   docker run -it --rm alpine:3
   ```

1. Automate more complex tasks but they are not stable enough to be in a
   published image.

   In the Dockerfile,

   ```
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
     chmod +x /opt/sqlpackage/sqlpackage && \
     rm -rf /var/lib/apt/lists/*
   ```

   In the docker-compose.yml,

   ```
   app:
     build: .
     working_dir: /app
     volumes:
     - .:/app
   ```

   Then I can use it like this,

   ```
   docker-compose run --rm app sqlcmd -Q 'CREATE DATABASE HelloWorld'
   ```
