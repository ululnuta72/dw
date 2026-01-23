# =========================
# 1) BUILDER
# =========================
FROM node:20-bookworm-slim AS builder

WORKDIR /app

# install git
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

COPY app/ .
RUN npm install

# kalau ada build step
# RUN npm run build

# =========================
# 2) RUNTIME (XFCE + VNC)
# =========================
FROM --platform=linux/amd64 debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    dbus-x11 \
    ca-certificates \
    openssl \
    git \
    git-lfs \
    nodejs \
    npm \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN touch /root/.Xauthority

# copy app dari builder
COPY --from=builder /app /opt/app
WORKDIR /opt/app

EXPOSE 5901 6080

CMD bash -c "vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null"
