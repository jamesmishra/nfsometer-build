# nfsometer-build

## Introduction
This is a Docker image to build nfsometer as a single binary.

`nfsometer` is a program written for benchmarking Network File System (NFS) mounts.

It is a poorly-packaged Python 2 program, which makes it hard to run on any modern operating system.

This repository contains a Docker image that builds a self-contained binary to make it easy to run `nfsometer` on Linux systems that don't have Python 2 and the Python 2 packages that `nfsometer` depends on.

Because `nfsometer` is licensed under the GNU GPL v2, this Docker image is also under the GNU GPL v2.

## Dependencies

To build this image, you will need `make`, `docker`, and `docker-compose` on your system. All other dependencies will be installed in the Docker image and packaged in the binary.

## Usage

Run `make` and you will get a single binary named `nfsometer`.
