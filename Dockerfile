FROM alpine:3.19

# Install dependencies
# Kita tidak butuh systemd, snapd, atau PPA (Firefox di Alpine sudah native package, bukan snap)
RUN apk add --no-cache \
    bash \
    xfce4 \
    xfce4-terminal \
    tigervnc \
    novnc \
    websockify \
    firefox \
    sudo \
    curl \
    wget \
    git \
    tzdata \
    openssl \
    adwaita-icon-theme \
    ttf-dejavu \
    xorg-server-utils

# Setup environment
ENV USER=root
ENV DISPLAY=:1

# Konfigurasi VNC Password file (opsional, karena di CMD anda pakai SecurityTypes None, tapi good practice)
RUN mkdir -p /root/.vnc

# Expose ports
EXPOSE 5901
EXPOSE 6080

# Command
# Catatan: Path novnc di Alpine biasanya ada di /usr/share/novnc
CMD bash -c "vncserver :1 -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null"
