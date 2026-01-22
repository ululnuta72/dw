FROM alpine:3.19

# Install dependencies
# Ganti xfce4 dengan fluxbox
RUN apk add --no-cache \
    bash \
    fluxbox \
    xterm \
    tigervnc \
    novnc \
    websockify \
    firefox \
    sudo \
    curl \
    wget \
    openssl \
    adwaita-icon-theme \
    ttf-dejavu \
    xorg-server-utils

# Setup environment
ENV USER=root
ENV DISPLAY=:1

# Setup VNC
RUN mkdir -p /root/.vnc

# Konfigurasi Menu Fluxbox (Agar Firefox muncul di klik kanan)
# Ini opsional, tapi membantu agar mudah menjalankan aplikasi
RUN mkdir -p /root/.fluxbox && \
    echo '[begin] (Fluxbox)' > /root/.fluxbox/menu && \
    echo '  [exec] (Terminal) {xterm}' >> /root/.fluxbox/menu && \
    echo '  [exec] (Firefox) {firefox}' >> /root/.fluxbox/menu && \
    echo '  [submenu] (Tools)' >> /root/.fluxbox/menu && \
    echo '      [exec] (Refresh) {xrefresh}' >> /root/.fluxbox/menu && \
    echo '  [end]' >> /root/.fluxbox/menu && \
    echo '  [exit] (Exit)' >> /root/.fluxbox/menu && \
    echo '[end]' >> /root/.fluxbox/menu

EXPOSE 5901
EXPOSE 6080

# Command
# Perhatikan kita mengganti startxfce4 dengan fluxbox
CMD bash -c "vncserver :1 -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    fluxbox"
