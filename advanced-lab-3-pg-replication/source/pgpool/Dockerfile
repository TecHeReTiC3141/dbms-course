FROM pgpool/pgpool:latest

USER root

# Копируем конфиг и скрипты
COPY --chown=pgpool:pgpool scripts/ /usr/local/bin/pgpool-scripts/

# ОДНИМ RUN делаем всё: права, владельца, конвертация CRLF
RUN chmod +x /usr/local/bin/pgpool-scripts/*.sh

# Переключаемся на пользователя pgpool для безопасности
USER postgres

# Команда запуска
CMD ["pgpool", "-n"]