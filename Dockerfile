# =========================
# 1) BUILDER
# =========================
FROM node:current-bookworm-slim AS builder

WORKDIR /app

# install git
RUN apt-get update && apt-get install -y --no-install-recommends \
    git git-lfs \
    && git lfs install \
    && git lfs pull \
    && rm -rf /var/lib/apt/lists/*

COPY app/ .
RUN npm install

# kalau ada build step
# RUN npm run build

# =========================
# 2) RUNTIME (XFCE + VNC)
# =========================
FROM node:current-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

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
    && rm -rf /var/lib/apt/lists/*

# XFCE session
RUN echo "exec startxfce4 &" > /root/.xsession \
    && touch /root/.Xauthority

# copy app dari builder
COPY --from=builder /app /root/app
WORKDIR /root/app

EXPOSE 5901 6080

CMD bash -c "vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null"
