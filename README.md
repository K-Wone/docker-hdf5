# Supported tags

- `1.10.5-openmpi-4, 1.10.5-openmpi-3`
- `1.10.5-gcc-9, 1.10.5-gcc-8, 1.10.5-gcc-7`
- `1.10.5-clang-9`

# How to use

```bash
docker build -t my-repo/hdf5 .
docker run -it --rm my-repo/hdf5
```

A bunch of build-time arguments can be used to build HDF5.

```bash
docker build -t my-repo/hdf5 \
        --build-arg IMAGE_NAME="leavesask/gcc:latest" \
        --build-arg HDF5_VMAJOR="1.10" \
        --build-arg HDF5_VMINOR="5" \
        --build-arg HDF5_CONFIGURE_ENV="CC=gcc CXX=g++" \
        --build-arg HDF5_OPTIONS="--enable-cxx"
```

Arguments and their defaults are listed below.

- `BASE_IMAGE`: IMAGE_NAME\[:TAG\] (default=`leavesask/gompi:latest`)
  - This is the image we used for all of the stages.
  - It is supposed to a toolchain containing compilers.

- `HDF5_VMAJOR`: X.X (default=`1.10`)

- `HDF5_VMINOR`: X (default=`5`)

- `HDF5_CONFIGURE_ENV`: key=value (default=`CC=mpicc CXX=mpicxx`)
  - Environment variables needed to configure the installation.

- `HDF5_OPTIONS`: (default=`--enable-cxx --enable-parallel --enable-unsupported`)
  - Options needed to configure the installation.
  - The default installation path is `/opt/hdf5/${HDF5_VERSION}` so that option `--prefix` is unnecessary.

- `USER_NAME`: user (default=`root`)
  - This must be an existing user in the base image.
