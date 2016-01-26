#!/bin/bash

FWDIR="$(cd `dirname $0`; pwd)"

if [ -z ${KEYSTONE_DIR+x} ]; then
    echo "KEYSTONE_DIR must be set"
    exit 1
fi

KEYSTONE_DIR=$(FWDIR)/../../keystone

git clone -b $KEYSTONE_VERSION --single-branch \
  https://github.com/amplab/keystone.git $KEYSTONE_DIR

pushd $KEYSTONE_DIR
sbt/sbt 'set version:="INTEGRATION-SNAPSHOT"' publish-local
popd