# stage 1: build HDF5 with the specified toolchain
ARG BASE_IMAGE="leavesask/gompi"
ARG BASE_TAG="latest"
FROM ${BASE_IMAGE}:${BASE_TAG} AS builder

USER root

# install basic buiding tools
RUN set -eu; \
      \
      sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' \
             /etc/apk/repositories; \
      apk add --no-cache \
              autoconf \
              automake \
              make \
              wget \
              which

# stage 1.1: download HDF5 source
ARG HDF5_VMAJOR="1.10"
ENV HDF5_VMAJOR=${HDF5_VMAJOR}
ARG HDF5_VMINOR="5"
ENV HDF5_VMINOR=${HDF5_VMINOR}
ENV HDF5_VERSION="${HDF5_VMAJOR}.${HDF5_VMINOR}"
ENV HDF5_TARBALL="hdf5-${HDF5_VERSION}.tar.gz"

WORKDIR /tmp
RUN set -eux; \
      \
      # checksums are not provided due to the build-time arguments HDF5_VERSION
      wget "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VMAJOR}/hdf5-${HDF5_VERSION}/src/${HDF5_TARBALL}"; \
      tar -xzf ${HDF5_TARBALL}

# stage 1.2: build and install HDF5
ARG HDF5_CC="mpicc"
ENV HDF5_CC=${HDF5_CC}
ARG HDF5_CXX="mpicxx"
ENV HDF5_CXX=${HDF5_CXX}
ARG HDF5_OPTIONS="--enable-cxx --enable-parallel --enable-unsupported"
ENV HDF5_OPTIONS=${HDF5_OPTIONS}
ENV HDF5_PREFIX="/opt/hdf5/${HDF5_VERSION}"

WORKDIR /tmp/hdf5-${HDF5_VERSION}
RUN set -eux; \
      \
      # configure HDF5 installation with specified env and options
      ./configure \
                  CC=${HDF5_CC} \
                  CXX=${HDF5_CXX} \
                  --prefix=${HDF5_PREFIX} \
                  ${HDF5_OPTIONS} \
      ; \
      make -j "$(nproc)"; \
      make install; \
      \
      rm -rf hdf5-${HDF5_VERSION} ${HDF5_TARBALL}


# stage 2: build the runtime environment
ARG BASE_IMAGE
ARG BASE_TAG
FROM ${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Wang An <wangan.cs@gmail.com>"

USER root

# install basic dev tools
RUN set -eu; \
      \
      sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' \
             /etc/apk/repositories; \
      apk add --no-cache \
              make

# renew environment variables
ARG HDF5_VMAJOR="1.10"
ARG HDF5_VMINOR="5"
ENV HDF5_VERSION="${HDF5_VMAJOR}.${HDF5_VMINOR}"
ENV HDF5_PATH="/opt/hdf5/${HDF5_VERSION}"

# copy artifacts from stage 1
COPY --from=builder ${HDF5_PATH} ${HDF5_PATH}

# set environment variables for users
ENV PATH="${HDF5_PATH}/bin:${PATH}"
ENV CPATH="${HDF5_PATH}/include:${CPATH}"
ENV LIBRARY_PATH="${HDF5_PATH}/lib:${LIBRARY_PATH}"
ENV LD_LIBRARY_PATH="${HDF5_PATH}/lib:${LD_LIBRARY_PATH}"

# transfer control to the default user
ARG USER_NAME=one
USER ${USER_NAME}

WORKDIR /home/${USER_NAME}


#-----------------------------------------------------------------------
# Build-time metadata as defined at http://label-schema.org
#-----------------------------------------------------------------------
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="HDF5 docker image" \
      org.label-schema.description="A lightweight image for HDF5" \
      org.label-schema.license="MIT" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url=${VCS_URL} \
      org.label-schema.schema-version="1.0"
