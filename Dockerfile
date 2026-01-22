FROM --platform=linux/amd64 alpine:3.19

RUN apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    tigervnc \
    novnc \
    websockify \
    sudo \
    bash \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata \
    dbus-x11 \
    firefox-esr \
    xf86-video-dummy \
    mesa-dri-gallium \
    font-noto \
    openssl \
    xvfb

RUN touch /root/.Xauthority

# Setup VNC password (optional, bisa dihapus jika ingin no password)
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

EXPOSE 5901 6080

CMD bash -c "Xvfb :1 -screen 0 1024x768x24 & \
    export DISPLAY=:1 && \
    startxfce4 & \
    x0vncserver -display :1 -rfbport 5901 -SecurityTypes None --I-KNOW-THIS-IS-INSECURE & \
    openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null"
