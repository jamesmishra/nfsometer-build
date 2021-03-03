FROM ubuntu:20.04 AS base
WORKDIR /build

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
    curl \
    git \
    build-essential \
    patchelf \
    python2.7 \
    python2.7-dev \
    python3.8 \
    python3.8-dev \
    python3-pip \
    python-pip-whl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl --fail --show-error --silent --location https://bootstrap.pypa.io/2.7/get-pip.py | python2.7

# Install nfsometer Python2 requirements.
RUN pip install --no-cache-dir \
    pyinstaller==3.6 \
    numpy \
    matplotlib \
    mako

# Clone the latest nfsometer.
RUN git clone git://git.linux-nfs.org/projects/dros/nfsometer.git

# Build a dynamically-linked Pyinstaller binary.
WORKDIR /build/nfsometer
RUN pyinstaller \
    --clean \
    --noconfirm \
    --hidden-import=nfsometerlib \
    --paths=./nfsometerlib \
    --add-data "nfsometerlib:nfsometerlib" \
    --onefile \
    nfsometer.py

RUN python3.8 -m pip --no-cache-dir install \
    staticx

RUN staticx /build/nfsometer/dist/nfsometer /build/nfsometer/dist/nfsometer-static

# When you run this image, mount the /host directory to the host filesystem.
ENTRYPOINT [ "/bin/bash", "-c", "cp /build/nfsometer/dist/nfsometer-static /host/nfsometer && chown $HOST_UID:$HOST_GID /host/nfsometer" ]
