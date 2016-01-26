#!/bin/bash

KEYSTONE_DIR=$(PWDIR)/../../keystone

git clone -b $KEYSTONE_VERSION --single-branch \
  https://github.com/amplab/keystone.git $KEYSTONE_DIR

pushd
cd $KEYSTONE_DIR
sbt/sbt 'set version:="INTEGRATION-SNAPSHOT"' publish-local
popd