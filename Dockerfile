FROM node:current-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root/app

# =========================
# SYSTEM DEPENDENCIES
# =========================
RUN apt-get update && apt-get install --no-install-recommends -y \
    firefox-esr \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    dbus-x11 \
    ca-certificates \
    openssl \
    ffmpeg \
    git \
    git-lfs \
    && git lfs install \
    && rm -rf /var/lib/apt/lists/*

# =========================
# XFCE SESSION
# =========================
RUN echo "exec startxfce4 &" > /root/.xsession \
    && touch /root/.Xauthority

# RUN git clone https://github.com/ululnuta72/sflow.git . \
#     && git lfs pull \
#     && npm install

# kalau ada build step
# RUN npm run build

# =========================
# PORTS
# =========================
EXPOSE 5901 6080

# =========================
# START SERVICES
# =========================
CMD bash -c "\
    vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null"
