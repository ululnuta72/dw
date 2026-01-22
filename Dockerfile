FROM --platform=linux/amd64 debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    sudo \
    vim \
    curl \
    wget \
    dbus-x11 \
    firefox-esr \
    openssl \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.vnc && touch /root/.Xauthority

EXPOSE 5901 6080

CMD bash -c "\
    echo '=== Starting VNC Server ===' && \
    vncserver :1 -geometry 1024x768 -depth 24 -localhost no -SecurityTypes None && \
    sleep 2 && \
    echo '=== Generating SSL certificate ===' && \
    openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out /root/self.pem -keyout /root/self.pem && \
    echo '=== Starting websockify ===' && \
    websockify --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901 & \
    sleep 2 && \
    echo '=== VNC Server Status ===' && \
    ps aux | grep vnc && \
    echo '=== noVNC available at http://localhost:6080/vnc.html ===' && \
    tail -f /root/.vnc/*.log"
