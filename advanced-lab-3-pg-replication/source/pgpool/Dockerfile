FROM pgpool/pgpool:latest

USER root

# Скрипты failover (путь должен совпадать с PGPOOL_PARAMS_FAILOVER_COMMAND в compose)
COPY scripts/ /usr/local/bin/pgpool-scripts/
RUN chmod +x /usr/local/bin/pgpool-scripts/*.sh \
  && chown -R postgres:postgres /usr/local/bin/pgpool-scripts

# Образ pgpool/pgpool: USER postgres; бинарник в /opt/pgpool-II/bin (не в PATH).
# CMD «pgpool -n» даёт: exec: pgpool: not found — используйте start.sh из образа.
USER postgres
CMD ["/opt/pgpool-II/bin/start.sh"]