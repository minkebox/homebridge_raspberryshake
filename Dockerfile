FROM continuumio/miniconda3:4.8.2-alpine

USER root

# Install the pieces we need
RUN apk add git bash coreutils ffmpeg tk mesa-gl \
  nodejs nodejs-npm dbus avahi avahi-compat-libdns_sd curl

# Raspberry Shake pieces
RUN git clone --depth 1 https://github.com/aanon4/rsudp.git ;\
  touch /root/.bashrc ;\
  ln -s /opt/conda /root/miniconda3 ;\
  bash /rsudp/unix-install-rsudp.sh

# Homebridge pieces
COPY root/ /root
RUN rm -f /etc/avahi/services/* ;\
  cd /root ; npm install

# Minkebox
COPY minkebox/ /minkebox

# Bolt it all together
COPY startup.sh /startup.sh

VOLUME [ "/root/rsudp/screenshots", "/root/homebridge" ]
EXPOSE 8888/udp 51826

CMD /startup.sh
