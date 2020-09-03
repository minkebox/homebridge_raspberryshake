FROM continuumio/miniconda3:4.8.2-alpine

USER root

# Raspberry Shake pieces
RUN apk add git bash coreutils ffmpeg tk mesa-gl
RUN git clone --depth 1 https://github.com/aanon4/rsudp.git
RUN touch /root/.bashrc
RUN ln -s /opt/conda /root/miniconda3
RUN bash /rsudp/unix-install-rsudp.sh

# Homebridge pieces
RUN apk add nodejs nodejs-npm dbus avahi avahi-compat-libdns_sd curl
RUN rm -f /etc/avahi/services/*
COPY root/ /root
RUN cd /root ; npm install

# Minkebox
COPY minkebox/ /minkebox

ADD startup.sh /startup.sh

VOLUME [ "/root/rsudp/screenshots", "/root/homebridge" ]
EXPOSE 8888/udp 51826

CMD /startup.sh
