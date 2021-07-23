FROM debian:stretch
ARG DOCKERIZE_VERSION=v0.2.0

RUN groupadd -r postgres --gid=999 && useradd -r -g postgres -d /home/postgres  --uid=999 postgres

# grab gosu for easy step-down from root
ARG GOSU_VERSION=1.11
RUN set -eux \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget gnupg2 libffi-dev openssh-server gosu && rm -rf /var/lib/apt/lists/*  && \
	gosu nobody true

COPY ./dockerfile/bin /usr/local/bin/dockerfile
RUN chmod -R +x /usr/local/bin/dockerfile && ln -s /usr/local/bin/dockerfile/functions/* /usr/local/bin/

RUN  wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - && \
     sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' && \
     apt-get update

RUN  apt-get install -y postgresql-client-13 net-tools arping make gcc flex bison libpq-dev postgresql-server-dev-13/stretch-pgdg


RUN install_deb_pkg "http://launchpadlibrarian.net/160156688/libmemcached10_1.0.8-1ubuntu2_amd64.deb" "libmemcached10"
RUN install_deb_pkg "http://security-cdn.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb" "libssl1.0.0"
#RUN install_deb_pkg "http://atalia.postgresql.org/morgue/libpgpool0_4.1.4-2.pgdg90+1_amd64.deb" "libpgpool0"
#RUN install_deb_pkg "http://atalia.postgresql.org/morgue/pgpool2_4.1.4-2.pgdg90+1_amd64.deb" "pgpool2"
#RUN install_deb_pkg "http://atalia.postgresql.org/morgue/postgresql-server-dev-all_225.pgdg90+1_all.deb" "postgresql-server-dev"

RUN  wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
     tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN  wget https://www.pgpool.net/mediawiki/download.php?f=pgpool-II-4.2.3.tar.gz -O pgpool-II-4.2.3.tar.gz && \
    tar -xzvf pgpool-II-4.2.3.tar.gz && \
    cd ./pgpool-II-4.2.3 && \
    ./configure && \
    make && \
    make install && \
    cd ./src/sql/pgpool-recovery && \
    make && \
    make install && \
    cd ../pgpool-regclass && \
    make && \
    make install

