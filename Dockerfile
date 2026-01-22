FROM alpine:3.19

# 1. Setup Repositories (PENTING: novnc & fluxbox ada di community repo)
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

# 2. Install Dependencies
# - xorg-server-utils diganti dengan xrandr dan xdpyinfo
# - novnc & websockify diinstal langsung dari apk (tersedia di community)
RUN apk update && apk add --no-cache \
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
    xrandr \
    xdpyinfo

# 3. Setup Environment
ENV USER=root
ENV DISPLAY=:1

# 4. Setup VNC & Fluxbox Menu
RUN mkdir -p /root/.vnc && \
    mkdir -p /root/.fluxbox && \
    # Buat menu klik kanan sederhana
    echo '[begin] (Fluxbox)' > /root/.fluxbox/menu && \
    echo '  [exec] (Firefox) {firefox}' >> /root/.fluxbox/menu && \
    echo '  [exec] (Terminal) {xterm}' >> /root/.fluxbox/menu && \
    echo '  [separator]' >> /root/.fluxbox/menu && \
    echo '  [exec] (Exit) {exit}' >> /root/.fluxbox/menu && \
    echo '[end]' >> /root/.fluxbox/menu

# 5. Setup Ports
EXPOSE 5901
EXPOSE 6080

# 6. Command
# Catatan: Path index.html novnc di Alpine ada di /usr/share/novnc
CMD bash -c "vncserver :1 -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    fluxbox"
