FROM phusion/baseimage:latest
LABEL maintainer="Gawindx <decauxnico@gmail.com>"

ARG HASSIO_ARCH=amd64 \
    MQTT_LOGIN="mosquitto" \
    MQTT_PASSWD="mosquitto"

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TZ="Europe/Paris" \
    DEBIAN_FRONTEND=noninteractive

# Install Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
#            build-essential \
#            git \
            python \
            python2.7 \
            python3 && \
#    apt-get remove -y autoconf automake && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Install mosquitto
ADD rootfs/ /
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            mosquitto && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Install Home Assistant
RUN python3 -m venv homeassistant && \
    cd homeassistant && \
    source bin/activate && \
    python3 -m pip install homeassistant && \
    hass --open-ui
EXPOSE 8123/tcp 1883/tcp

CMD ["hass", "--open-ui"]
