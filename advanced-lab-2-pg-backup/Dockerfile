FROM postgres:latest

RUN apt-get update && \
  apt-get install -y openssh-server cron && \
  mkdir /var/run/sshd

# Разрешаем root вход (для лабораторной)
RUN echo 'root:root' | chpasswd

EXPOSE 22
