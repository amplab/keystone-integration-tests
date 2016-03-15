#!/bin/bash
FWDIR="$(cd `dirname $0`; pwd)"

bash $FWDIR/run-pipeline-yarn.sh $@
