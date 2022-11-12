ARG ROS_TAG=noetic

FROM ros:$ROS_TAG
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV HOME=/root
ENV ATHOME_WS=$HOME/athome_ws

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3-pip \
    python3-catkin-lint \
    python3-catkin-tools \
    python3-osrf-pycommon \
    ros-$ROS_DISTRO-cv-bridge \
    ros-$ROS_DISTRO-diagnostic-updater \
    ros-$ROS_DISTRO-graph-msgs \
    ros-$ROS_DISTRO-image-transport \
    ros-$ROS_DISTRO-rosbridge-server \
    && rm -rf /var/lib/apt/lists/*

COPY . $ATHOME_WS/src

WORKDIR $ATHOME_WS
RUN for file in $(find ./src -type f -name "requirements.txt"); do \
    # Install all python dependencies
    echo "Installing python requirements from $file"; \
    pip3 install -r $file; \
    done \
    && catkin config \
    --extend /opt/middlewares_deps \
    --cmake-args -DCMAKE_BUILD_TYPE=Release \
    && catkin build --no-status athome_vision

RUN echo "source \$ATHOME_WS/devel/setup.bash" >> $HOME/.bashrc

COPY entrypoint.sh /

WORKDIR $ATHOME_WS
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]