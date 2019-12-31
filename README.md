[![Layers](https://images.microbadger.com/badges/image/leavesask/hdf5.svg)](https://microbadger.com/images/leavesask/hdf5)
[![Version](https://images.microbadger.com/badges/version/leavesask/hdf5.svg)](https://hub.docker.com/repository/docker/leavesask/hdf5)
[![Commit](https://images.microbadger.com/badges/commit/leavesask/hdf5.svg)](https://github.com/K-Wone/docker-hdf5)
[![License](https://images.microbadger.com/badges/license/leavesask/hdf5.svg)](https://github.com/K-Wone/docker-hdf5)
[![Docker Pulls](https://img.shields.io/docker/pulls/leavesask/hdf5?color=informational)](https://hub.docker.com/repository/docker/leavesask/hdf5)
[![Automated Build](https://img.shields.io/docker/automated/leavesask/hdf5)](https://hub.docker.com/repository/docker/leavesask/hdf5)

# Supported tags

- `1.10.5-gompi, 1.10.5-gompi-4.0.0, 1.10.5-gompi-3.1.5`
- `1.10.5-gcc, 1.10.5-gcc-9.2.0, 1.10.5-gcc-8.3.0, 1.10.5-gcc-7.3.0`
- `1.10.5-clang`

# How to use

1. [Install docker engine](https://docs.docker.com/install/)

2. Pull the image
  ```bash
  docker pull leavesask/hdf5:<tag>
  ```

3. Run the image interactively
  ```bash
  docker run -it --rm leavesask/hdf5:<tag>
  ```

# How to build

## make

There are a bunch of build-time arguments you can use to build the image.

It is hightly recommended that you build the image with `make`.

```bash
# Build an image for HDF5 1.10.5
make

# Build and publish the image
make release
```

Check `Makefile` for more options.

## docker build

As an alternative, you can build the image with `docker build` command.

```bash
docker build \
        --build-arg BASE_IMAGE="leavesask/gcc" \
        --build-arg BASE_TAG="latest" \
        --build-arg HDF5_VMAJOR="1.10" \
        --build-arg HDF5_VMINOR="5" \
        --build-arg HDF5_CC="gcc" \
        --build-arg HDF5_CXX="g++" \
        --build-arg HDF5_OPTIONS="--enable-cxx" \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        --build-arg VCS_REF=`git rev-parse --short HEAD` \
        -t my-repo/hdf5:latest .
```

Arguments and their defaults are listed below.

- `BASE_IMAGE`: value (default=`leavesask/gompi`)
  - This is the base image for all of the stages.
  - It is supposed to be a toolchain containing compilers.

- `BASE_TAG`: value (default=`latest`)

- `HDF5_VMAJOR`: X.X (default=`1.10`)

- `HDF5_VMINOR`: X (default=`5`)

- `HDF5_CC`: value (default=`mpicc`)
- `HDF5_CXX`: value (default=`mpicxx`)

- `HDF5_OPTIONS`: option\[=value\] (default=`--enable-cxx --enable-parallel --enable-unsupported`)
  - Options needed to configure the installation.
  - The default installation path is `/opt/hdf5/${HDF5_VERSION}` so that option `--prefix` is unnecessary.

- `USER_NAME`: value (default=`one`)
  - This must be an existing user in the base image.
