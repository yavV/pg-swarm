FROM postgis/postgis:13-master

RUN apt-get update --fix-missing && \
    apt-get install -y wget openssh-server barman-cli

COPY ./dockerfile/bin /usr/local/bin/dockerfile
RUN chmod -R +x /usr/local/bin/dockerfile && ln -s /usr/local/bin/dockerfile/functions/* /usr/local/bin/


RUN install_deb_pkg "http://atalia.postgresql.org/morgue/repmgr-common_5.2.0-1.pgdg+1_all.deb"
RUN install_deb_pkg "http://atalia.postgresql.org/morgue/postgresql-13-repmgr_5.2.0-1.pgdg+1_amd64.deb"



COPY ./pgsql/bin /usr/local/bin/cluster
RUN chmod -R +x /usr/local/bin/cluster
RUN ln -s /usr/local/bin/cluster/functions/* /usr/local/bin/
COPY ./pgsql/configs /var/cluster_configs

COPY ./ssh /tmp/.ssh
RUN mv /tmp/.ssh/sshd_start /usr/local/bin/sshd_start && chmod +x /usr/local/bin/sshd_start

EXPOSE 22
EXPOSE 5432

#VOLUME /var/lib/postgresql/data
USER root

RUN  apt-get install -y net-tools

CMD ["/usr/local/bin/cluster/entrypoint.sh"]
#CMD ["/docker-entrypoint-initdb.d/10_postgis.sh"]
#CMD ["postgres"]
