FROM kalilinux/kali-rolling:latest

LABEL maintainer="hacking-lab"
LABEL description="Kali Linux environment for ethical hacking and penetration testing practice"

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=kali
ENV HOME=/home/kali

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tree \
    unzip \
    sudo \
    python3 \
    python3-pip \
    nodejs \
    npm \
    openjdk-11-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    kali-tools-top10 \
    kali-tools-web \
    kali-tools-information-gathering \
    kali-tools-vulnerability \
    kali-tools-passwords \
    kali-tools-wireless \
    kali-tools-forensics \
    kali-tools-reverse-engineering \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    nmap \
    masscan \
    gobuster \
    dirb \
    nikto \
    sqlmap \
    burpsuite \
    wireshark \
    tcpdump \
    netcat-traditional \
    socat \
    metasploit-framework \
    hydra \
    john \
    hashcat \
    aircrack-ng \
    reaver \
    binwalk \
    foremost \
    volatility3 \
    gdb \
    radare2 \
    ghidra \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    requests \
    beautifulsoup4 \
    scapy \
    pwntools \
    paramiko \
    impacket \
    python-nmap \
    colorama \
    termcolor

RUN useradd -m -s /bin/bash -G sudo $USER && \
    echo "$USER:kali" | chpasswd && \
    echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /home/kali/tools /home/kali/wordlists /home/kali/scripts /home/kali/lab

RUN mkdir -p /usr/share/wordlists && \
    cd /usr/share/wordlists && \
    wget -q https://github.com/danielmiessler/SecLists/archive/master.zip -O seclists.zip && \
    unzip -q seclists.zip && \
    mv SecLists-master SecLists && \
    rm seclists.zip && \
    ln -s /usr/share/wordlists /home/kali/wordlists/

RUN mkdir -p /home/kali/scripts && \
    echo '#!/bin/bash\necho "Kali Linux Hacking Lab Environment"\necho "Available tools: nmap, burpsuite, metasploit, wireshark, etc."\necho "Wordlists available in: ~/wordlists/"' > /home/kali/scripts/info.sh && \
    chmod +x /home/kali/scripts/info.sh

RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    dbus-x11 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN chown -R kali:kali /home/kali

USER kali
WORKDIR /home/kali

RUN mkdir -p ~/.vnc && \
    echo "kali" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

USER root
RUN echo '#!/bin/bash\n\
echo "Starting Kali Linux Hacking Lab..."\n\
service ssh start\n\
su - kali -c "vncserver :1 -geometry 1920x1080 -depth 24" &\n\
echo "SSH server started on port 22"\n\
echo "VNC server started on port 5901"\n\
echo "Login credentials - User: kali, Password: kali"\n\
/bin/bash\n\
' > /start.sh && chmod +x /start.sh

EXPOSE 22 5901 8080 4444

CMD ["/start.sh"]