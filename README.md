[![Layers](https://images.microbadger.com/badges/image/leavesask/hdf5.svg)](https://microbadger.com/images/leavesask/hdf5)
[![Version](https://images.microbadger.com/badges/version/leavesask/hdf5.svg)](https://hub.docker.com/repository/docker/leavesask/hdf5)
[![Commit](https://images.microbadger.com/badges/commit/leavesask/hdf5.svg)](https://github.com/K-Wone/docker-openmpi)
[![Docker Pulls](https://img.shields.io/docker/pulls/leavesask/hdf5?color=informational)](https://hub.docker.com/repository/docker/leavesask/hdf5)
[![Automated Build](https://img.shields.io/docker/automated/leavesask/hdf5)](https://hub.docker.com/repository/docker/leavesask/hdf5)

# Supported tags

- `1.10.5-openmpi, 1.10.5-openmpi-4, 1.10.5-openmpi-3`
- `1.10.5-gcc, 1.10.5-gcc-9, 1.10.5-gcc-8, 1.10.5-gcc-7`
- `1.10.5-clang, 1.10.5-clang-9`

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

There are a bunch of build-time arguments you can use to build the HDF5 image.

```bash
docker build \
        --build-arg BASE_IMAGE="leavesask/gcc:latest" \
        --build-arg HDF5_VMAJOR="1.10" \
        --build-arg HDF5_VMINOR="5" \
        --build-arg HDF5_CC="gcc" \
        --build-arg HDF5_CXX="g++" \
        --build-arg HDF5_OPTIONS="--enable-cxx" \
        -t my-repo/hdf5 .
```

Arguments and their defaults are listed below.

- `BASE_IMAGE`: name\[:tag\] (default=`leavesask/gompi:latest`)
  - This is the base image for all of the stages.
  - It is supposed to be a toolchain containing compilers.

- `HDF5_VMAJOR`: X.X (default=`1.10`)

- `HDF5_VMINOR`: X (default=`5`)

- `HDF5_CC`: value (default=`mpicc`)
- `HDF5_CXX`: value (default=`mpicxx`)

- `HDF5_OPTIONS`: option\[=value\] (default=`--enable-cxx --enable-parallel --enable-unsupported`)
  - Options needed to configure the installation.
  - The default installation path is `/opt/hdf5/${HDF5_VERSION}` so that option `--prefix` is unnecessary.

- `USER_NAME`: value (default=`one`)
  - This must be an existing user in the base image.
