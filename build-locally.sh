#!/bin/bash

export CONFIG=python3.7
export DOCKER_IMAGE="condaforge/linux-anvil-comp7"

CBA_FLAGS="-vvv --cycle-packages"
if [ -n "$INCLUDE_JINJA" ]; then
    CBA_FLAGS="$CBA_FLAGS --build-only-jinja $INCLUDE_JINJA"
fi
if [ -n "$EXCLUDE_JINJA" ]; then
    CBA_FLAGS="$CBA_FLAGS --no-build-jinja $EXCLUDE_JINJA"
fi
if [ ! -z "$NIGHTLY"]; then
    CBA_FLAGS="$CBA_FLAGS --dev --scheduled-only --upload omnia-dev"
fi
if [ ! -z "$BETA"]; then
    CBA_FLAGS="$CBA_FLAGS --upload omnia"
fi
export CBA_FLAGS=${CBA_FLAGS}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOCKER_FLAGS="--rm -it"
DOCKER_DIRS="-v $DIR:/io:rw,z"
DOCKER_DIRS+=" -v $DIR/.conda_configs:/conda_configs"
DOCKER_VARS="-e CBA_FLAGS -e CONFIG"
DOCKER_COMMAND="bash" # /io/devtools/docker-build.sh"
docker run ${DOCKER_FLAGS} ${DOCKER_DIRS} ${DOCKER_VARS} ${DOCKER_IMAGE} ${DOCKER_COMMAND}
