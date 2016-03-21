
#!/bin/bash

# Figure out where we are.
FWDIR="$(cd `dirname $0`; pwd)"

CLASS=$1
shift

# Figure out where the Scala framework is installed
FWDIR="$(cd `dirname $0`/..; pwd)"

if [ -z "$1" ]; then
  echo "Usage: run-main.sh <class> [<args>]" >&2
  exit 1
fi

if [ -z "$OMP_NUM_THREADS" ]; then
    export OMP_NUM_THREADS=1 # added as we were nondeterministically running into an openblas race condition
    echo "automatically setting OMP_NUM_THREADS=$OMP_NUM_THREADS"
fi


JARFILE="$FWDIR/target/scala-2.10/keystone-app-assembly.jar"

# TODO: Figure out a way to pass in either a conf file / flags to spark-s   ubmit
KEYSTONE_MEM=${KEYSTONE_MEM:-1g}
export KEYSTONE_MEM
LD_LIBRARY_PATH=/opt/amp/gcc/lib64:/opt/amp/openblas/lib:$LD_LIBRARY_PATH

# Set some commonly used config flags on the cluster
spark-submit \
  --master yarn \
  --class $CLASS \
  --num-executors 10 \
  --executor-cores 10 \
  --driver-class-path $JARFILE:$HOME/hadoop/conf \
  --driver-library-path /opt/amp/openblas/lib:$FWDIR/../lib:$KEYSTONE_DIR/lib \
  --conf spark.executor.extraLibraryPath=/opt/amp/openblas/lib:$FWDIR/../lib:$KEYSTONE_DIR/lib \
  --conf spark.executor.extraClassPath=$JARFILE:$HOME/hadoop/conf \
  --conf spark.serializer=org.apache.spark.serializer.JavaSerializer \
  --conf spark.executorEnv.LD_LIBRARY_PATH=/opt/amp/gcc/lib64:/opt/amp/openblas/lib:$LD_LIBRARY_PATH\
  --conf spark.yarn.executor.memoryOverhead=15300 \
  --conf spark.mlmatrix.treeBranchingFactor=16 \
  --conf spark.network.timeout=600 \
  --conf spark.executorEnv.OMP_NUM_THREADS=1 \
  --driver-memory 100g \
  --conf spark.driver.maxResultSize=0 \
  --executor-memory $KEYSTONE_MEM \
  $JARFILE \
  "$@"
