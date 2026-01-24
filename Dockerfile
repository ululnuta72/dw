FROM --platform=linux/amd64 debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# =========================
# CORE PACKAGES (MINIMAL)
# =========================
RUN apt-get update && apt-get install --no-install-recommends -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    dbus-x11 \
    x11-xserver-utils \
    ca-certificates \
    openssl \
    curl \
    wget \
    git \
    tzdata \
    firefox-esr \
    xubuntu-icon-theme \
    && rm -rf /var/lib/apt/lists/*

# =========================
# XFCE SESSION
# =========================
RUN echo "exec startxfce4 &" > /root/.xsession \
    && touch /root/.Xauthority

# =========================
# PORTS
# =========================
EXPOSE 5901 6080

# =========================
# START VNC + noVNC
# =========================
CMD ["bash", "-c", "vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && tail -f /dev/null"]
