#===============================================================================
# Default User Options
#===============================================================================

# Build-time arguments
BASE_IMAGE   ?= leavesask/gompi
BASE_TAG     ?= latest
HDF5_VMAJOR  ?= 1.10
HDF5_VMINOR  ?= 5
HDF5_CC      ?= mpicc
HDF5_CXX     ?= mpicxx
HDF5_OPTIONS ?= "--enable-cxx --enable-parallel --enable-unsupported"

# Image name
DOCKER_IMAGE ?= leavesask/hdf5
DOCKER_TAG   := $(HDF5_VMAJOR).$(HDF5_VMINOR)

# Default user
USER_NAME    ?= one

#===============================================================================
# Variables and objects
#===============================================================================

# Append a suffix to the tag if the version number of toolchain
# is specified
DOCKER_REPO       := $(lastword $(subst /, ,$(BASE_IMAGE)))
DOCKER_TAG_SHORT  := $(DOCKER_TAG)-$(DOCKER_REPO)
DOCKER_TAG        := $(DOCKER_TAG)-$(DOCKER_REPO)
ifneq ($(BASE_TAG),latest)
    DOCKER_TAG := $(DOCKER_TAG)-$(BASE_TAG)
endif

BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VCS_URL=$(shell git config --get remote.origin.url)

# Get the latest commit
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))

#===============================================================================
# Targets to Build
#===============================================================================

.PHONY : docker_build docker_push output

default: build
build: docker_build output
release: docker_build docker_push output

docker_build:
	# Build Docker image
	docker build \
                 --build-arg BASE_IMAGE=$(BASE_IMAGE) \
                 --build-arg BASE_TAG=$(BASE_TAG) \
                 --build-arg HDF5_VMAJOR=$(HDF5_VMAJOR) \
                 --build-arg HDF5_VMINOR=$(HDF5_VMINOR) \
                 --build-arg HDF5_CC=$(HDF5_CC) \
                 --build-arg HDF5_CXX=$(HDF5_CXX) \
                 --build-arg HDF5_OPTIONS=$(HDF5_OPTIONS) \
                 --build-arg USER_NAME=$(USER_NAME) \
                 --build-arg BUILD_DATE=$(BUILD_DATE) \
                 --build-arg VCS_URL=$(VCS_URL) \
                 --build-arg VCS_REF=$(GIT_COMMIT) \
                 -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	# Tag image as latest
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest

	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest

	# Tag image with a short name
	if [[ "$(DOCKER_TAG_SHORT)" != "$(DOCKER_TAG)" ]]; then \
      docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):$(DOCKER_TAG_SHORT) && \
      docker push $(DOCKER_IMAGE):$(DOCKER_TAG_SHORT); \
    fi

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)
