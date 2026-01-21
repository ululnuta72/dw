FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Base packages
RUN apt update && apt install -y --no-install-recommends \
    sudo \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    x11-apps \
    xterm \
    tigervnc-standalone-server \
    novnc \
    websockify \
    openssl

# LXQt (Lubuntu desktop)
RUN apt install -y --no-install-recommends \
    lxqt-core \
    lxqt-session \
    lxqt-panel \
    lxqt-config \
    lxqt-runner \
    openbox \
    lubuntu-artwork \
    lxqt-themes

# Firefox (non-snap, sama seperti punya kamu)
RUN apt install -y software-properties-common \
 && add-apt-repository ppa:mozillateam/ppa -y \
 && echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox \
 && echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox \
 && echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox \
 && apt update \
 && apt install -y firefox

# Xauthority
RUN touch /root/.Xauthority

EXPOSE 5901
EXPOSE 6080

CMD bash -c "\
vncserver -localhost no -SecurityTypes None -geometry 1024x768 --I-KNOW-THIS-IS-INSECURE && \
openssl req -new -subj '/C=JP' -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
tail -f /dev/null"
