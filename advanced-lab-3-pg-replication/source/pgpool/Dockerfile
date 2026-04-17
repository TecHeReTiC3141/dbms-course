FROM pgpool/pgpool:4.4.3

USER root

# Копируем конфиг и скрипты
COPY pgpool.conf /etc/pgpool2/pgpool.conf
COPY scripts/ /usr/local/bin/pgpool-scripts/

# ОДНИМ RUN делаем всё: права, владельца, конвертация CRLF
RUN chmod +x /usr/local/bin/pgpool-scripts/*.sh && \
  chown -R pgpool:pgpool /usr/local/bin/pgpool-scripts

# Переключаемся на пользователя pgpool для безопасности
USER pgpool

# Команда запуска
CMD ["pgpool", "-n"]