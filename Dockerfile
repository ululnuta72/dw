FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# =========================
# CORE SYSTEM
# =========================
RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    openssl \
    curl \
    wget \
    git \
    git-lfs \
    ffmpeg \
    nodejs \
    npm \
    tzdata \
    dbus-x11 \
    x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

# =========================
# XFCE + VNC + noVNC
# =========================
RUN apt-get update && apt-get install --no-install-recommends -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    adwaita-icon-theme \
    && rm -rf /var/lib/apt/lists/*

# =========================
# FIREFOX (ESR)
# =========================
RUN apt-get update && apt-get install --no-install-recommends -y \
    firefox-esr \
    && rm -rf /var/lib/apt/lists/*

# =========================
# XFCE SESSION
# =========================
RUN echo "exec startxfce4 &" > /root/.xsession \
    && touch /root/.Xauthority

EXPOSE 5901 6080

CMD ["bash", "-c", "vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && tail -f /dev/null"]
