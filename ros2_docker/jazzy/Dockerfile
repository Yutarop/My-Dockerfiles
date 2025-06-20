# This Dockerfile is based on https://github.com/AtsushiSaito/docker-ubuntu-sweb
# which is released under the Apache-2.0 license.

FROM ubuntu:noble-20250404

ARG TARGETPLATFORM
LABEL maintainer="Yutarop<yutarop.storm.7@gmail.com>"

SHELL ["/bin/bash", "-c"]

# Upgrade OS
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Install Ubuntu Mate desktop
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ubuntu-mate-desktop && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Add Package
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tigervnc-standalone-server tigervnc-common \
    supervisor wget curl gosu git sudo python3-pip tini \
    build-essential vim sudo lsb-release locales \
    bash-completion tzdata terminator \
    iputils-ping net-tools \
    joystick jstest-gtk && \
    add-apt-repository ppa:mozillateam/ppa -y && \
    echo 'Package: firefox*' > /etc/apt/preferences.d/mozillateamppa && \
    echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozillateamppa && \
    echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozillateamppa && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt-get update && \
    apt-get install -y firefox code gimp && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# noVNC and Websockify
RUN git clone https://github.com/AtsushiSaito/noVNC.git -b add_clipboard_support /usr/lib/novnc
RUN pip install git+https://github.com/novnc/websockify.git@v0.10.0
RUN ln -s /usr/lib/novnc/vnc.html /usr/lib/novnc/index.html

# Set remote resize function enabled by default
RUN sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/lib/novnc/app/ui.js

# Disable auto update and crash report
RUN sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
RUN sed -i 's/enabled=1/enabled=0/g' /etc/default/apport

# Enable apt-get completion
RUN rm /etc/apt/apt.conf.d/docker-clean

# Install ROS
ENV ROS_DISTRO jazzy
# desktop or ros-base
ARG INSTALL_PACKAGE=desktop

RUN apt-get update -q && \
    apt-get install -y curl gnupg2 lsb-release && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update -q && \
    apt-get install -y ros-${ROS_DISTRO}-${INSTALL_PACKAGE} \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    python3-pip \
    python3-testresources \
    python3-wstool \
    gedit && \
    rosdep init && \
    rm -rf /var/lib/apt/lists/*

RUN rosdep update

# Install simulation package only on amd64
# https://github.com/Tiryoh/docker-ros2-desktop-vnc/pull/56#issuecomment-1196359860
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    apt-get update -q && \
    apt-get install -y \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-ros-ign && \
    rm -rf /var/lib/apt/lists/*; \
    fi

# Create 'ubuntu' user and set up ros2_ws directory
RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ubuntu && \
    echo "ubuntu:ubuntu" | /usr/sbin/chpasswd 2> /dev/null && \
    mkdir -p /home/ubuntu/ros2_ws/src && \
    chown -R ubuntu:ubuntu /home

# Clone packages related to livox and setup ip address
USER ubuntu
WORKDIR /home/ubuntu/ros2_ws/src
RUN mkdir livox && cd livox && \
    git clone https://github.com/Ericsii/livox_ros_driver2.git && \
    git clone https://github.com/porizou/livox_to_pointcloud2.git && \
    sed -i "s/192.168.1.5/192.168.3.1/g" ~/ros2_ws/src/livox/livox_ros_driver2/config/MID360_config.json && \
    sed -i "s/192.168.1.12/192.168.3.201/g" ~/ros2_ws/src/livox/livox_ros_driver2/config/MID360_config.json 
RUN mkdir unity && cd unity && \
    git clone https://github.com/Unity-Technologies/ROS-TCP-Endpoint.git && \
    git clone https://github.com/Unity-Technologies/ROS-TCP-Connector.git

# Switch to 'root' user for rosdep install
USER root
RUN apt-get update && \
    rosdep update && \
    rosdep install -r -y -i --from-paths /home/ubuntu/ros2_ws/src --rosdistro=${ROS_DISTRO} && \
    rm -rf /var/lib/apt/lists/*

# Build
USER ubuntu
WORKDIR /home/ubuntu/ros2_ws
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash; colcon build"

# Update .bashrc with custom aliases
RUN echo "" >> ~/.bashrc && \
    echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc && \
    echo "alias cm='cd ~/ros2_ws;colcon build;source ~/.bashrc'" >> ~/.bashrc

# Switch back to 'root' user
USER root
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/bin/bash", "-c", "/entrypoint.sh" ]

ENV USER ubuntu
ENV PASSWD ubuntu