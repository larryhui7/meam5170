FROM --platform=linux/amd64 ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl ca-certificates gnupg lsb-release git \
    python3 python3-pip python3-dev libspdlog1 \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/RobotLocomotion/drake/releases/download/v1.22.0/drake-dev_1.22.0-1_amd64-focal.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends ./drake-dev_1.22.0-1_amd64-focal.deb \
    && rm drake-dev_1.22.0-1_amd64-focal.deb && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir 'pin==3.3.1' 'crocoddyl==2.1.0' \
    && sed -i 's/^ruamel$/ruamel.yaml/' /tmp/requirements.txt \
    && python3 -m pip install --no-cache-dir -r /tmp/requirements.txt \
    && python3 -m pip install --no-cache-dir manipulation --no-dependencies \
    && python3 -m pip install --no-cache-dir 'drake==1.22.0'

ENV INHAND_HOME=/workspace/high_level
ENV QSIM_HOME=${INHAND_HOME}/quasistatic_simulator
ENV LD_LIBRARY_PATH=/opt/drake/lib
ENV PYTHONPATH=${INHAND_HOME}/planning_through_contact:${INHAND_HOME}/planner:${QSIM_HOME}:${QSIM_HOME}/quasistatic_simulator_cpp/build/bindings

WORKDIR /workspace/high_level/planner/ddp/tasks
