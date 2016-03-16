#!/bin/bash

FWDIR="$(cd `dirname $0`; pwd)"

export SPARK_VERSION=1.5.0-cdh5.5.1 
export SPARK_HADOOP_VERSION=2.6.0-cdh5.5.1 

if [ -z ${KEYSTONE_DIR+x} ]; then
    echo "KEYSTONE_DIR must be set"
    exit 1
fi

if [ -z ${KEYSTONE_VERSION+x} ]; then
    echo "KEYSTONE_VERSION must be set"
    exit 1
fi

if [ -z ${JAVA_HOME+x} ]; then
    echo "JAVA_HOME must be set"
    exit 1
fi

git clone -b $KEYSTONE_VERSION --single-branch \
  https://github.com/amplab/keystone.git $KEYSTONE_DIR

#Build the keystone version and publish it locally to a known verison number.
pushd $KEYSTONE_DIR
sbt/sbt compile
make
sbt/sbt 'set version:="INTEGRATION-SNAPSHOT"' publish-local
popd

#Build the keystone-integration-tests project against this.
sbt/sbt assembly
