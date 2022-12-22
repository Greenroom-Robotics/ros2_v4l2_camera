FROM ghcr.io/greenroom-robotics/ros_builder:humble-latest
ARG API_TOKEN_GITHUB

ENV PLATFORM_MODULE="ros2_v4l2_camera"
ENV GHCR_PAT=$API_TOKEN_GITHUB
ENV API_TOKEN_GITHUB=$API_TOKEN_GITHUB

RUN sudo mkdir /opt/greenroom && sudo chown ros:ros /opt/greenroom

RUN pip install git+https://github.com/Greenroom-Robotics/platform_cli.git@main

WORKDIR /home/ros/${PLATFORM_MODULE}
COPY ./package.xml ./package.xml

RUN platform pkg setup
RUN platform pkg install-deps

COPY ./ ./
RUN sudo chown -R ros:ros /home/ros/${PLATFORM_MODULE}

RUN platform poetry install   
RUN source ${ROS_OVERLAY}/setup.sh && platform ros build
RUN platform ros install_poetry_deps
   
ENV ROS_OVERLAY /opt/greenroom/${PLATFORM_MODULE}
RUN echo 'source ${ROS_OVERLAY}/setup.sh' >> ~/.profile

CMD tail -f /dev/null