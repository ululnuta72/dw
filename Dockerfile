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
    openssl

RUN touch /root/.Xauthority

EXPOSE 5901 6080

CMD bash -c "vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null"
