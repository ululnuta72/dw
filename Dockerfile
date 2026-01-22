FROM alpine:3.19

# 1. Setup Repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

# 2. Install Dependencies
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
    echo '[begin] (Fluxbox)' > /root/.fluxbox/menu && \
    echo '  [exec] (Firefox) {firefox}' >> /root/.fluxbox/menu && \
    echo '  [exec] (Terminal) {xterm}' >> /root/.fluxbox/menu && \
    echo '  [separator]' >> /root/.fluxbox/menu && \
    echo '  [exec] (Exit) {exit}' >> /root/.fluxbox/menu && \
    echo '[end]' >> /root/.fluxbox/menu

# 5. Fix NoVNC Index (PENTING AGAR BISA DIAKSES LANGSUNG)
# Kita pastikan vnc.html menjadi halaman utama (index.html)
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 5901
EXPOSE 6080

# 6. Command
# PERBAIKAN: 
# 1. Menghapus lock file X11 (penting saat container restart)
# 2. Menggunakan tanda kutip tunggal (') di dalam -subj agar tidak crash
CMD bash -c "rm -rf /tmp/.X1-lock /tmp/.X11-unix && \
    vncserver :1 -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    fluxbox"
