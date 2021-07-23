FROM pgpool-2-4.2.3-def:latest

RUN cd ~/
COPY ./ssh /tmp/.ssh
RUN mv /tmp/.ssh/sshd_start /usr/local/bin/sshd_start && chmod +x /usr/local/bin/sshd_start
RUN mv /usr/local/bin/pgpool /usr/sbin/

COPY ./pgpool/bin /usr/local/bin/pgpool
COPY ./pgpool/configs /var/pgpool_configs

RUN chmod +x -R /usr/local/bin/pgpool




ENV CONFIGS_DELIMITER_SYMBOL ,
ENV CONFIGS_ASSIGNMENT_SYMBOL :
                                #CONFIGS_DELIMITER_SYMBOL and CONFIGS_ASSIGNMENT_SYMBOL are used to parse CONFIGS variable
                                # if CONFIGS_DELIMITER_SYMBOL=| and CONFIGS_ASSIGNMENT_SYMBOL=>, valid configuration string is var1>val1|var2>val2

EXPOSE 22
EXPOSE 5432
EXPOSE 9898

HEALTHCHECK --interval=1m --timeout=10s --retries=5 \
  CMD /usr/local/bin/pgpool/has_write_node.sh

CMD ["/usr/local/bin/pgpool/entrypoint.sh"]
