#!/bin/bash

FWDIR="$(cd `dirname $0`; pwd)"

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <log_file.log>"
    exit 1
fi

grep -e $FWDIR/patterns.txt $1