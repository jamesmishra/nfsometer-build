# ===============================================================================
# The first stage of this Docker image builds a Pyinstaller binary with Python 2.
FROM python:2.7.18-buster AS pyinstaller_stage
WORKDIR /build

# Install Git so we can clone nfsometer.
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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



# ===============================================================================
# The second stage of this Docker image uses staticx (run through Python 3)
# to bundle the (formerly) dynamically-linked libraries.
FROM python:3.8.8-buster AS staticx_stage
WORKDIR /build
COPY --from=pyinstaller_stage /build/nfsometer/dist/nfsometer /build/nfsometer-dynamic

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
    build-essential \
    patchelf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3.8 -m pip --no-cache-dir install \
    staticx

RUN staticx /build/nfsometer-dynamic /build/nfsometer

# When you run this image, mount the /host directory to the host filesystem.
ENTRYPOINT [ "cp", "/build/nfsometer", "/host" ]