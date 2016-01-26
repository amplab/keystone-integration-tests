#!/bin/bash

if [ -z ${HADOOP_HOME+x} ]; then
    echo "HADOOP_HOME must be set"
    exit 1
fi

if [ -z ${HDFS_DIR+x} ]; then
    echo "HDFS_DIR must be set"
    exit 1
fi

#CIFAR Data

#Get the data
wget http://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz

#Decompress it
tar zxvf cifar-10-binary.tar.gz
cat cifar-10-batches-bin/data_batch*.bin > ./cifar_train.bin
mv cifar-10-batches-bin/test_batch.bin ./cifar_test.bin

#Copy to HDFS
$HADOOP_HOME/bin/hadoop fs -copyFromLocal ./cifar_train.bin $HDFS_DIR
$HADOOP_HOME/bin/hadoop fs -copyFromLocal ./cifar_test.bin $HDFS_DIR


#VOC Data

#Get the data
wget https://s3-us-west-2.amazonaws.com/voc-data/VOCtrainval_06-Nov-2007.tar
wget https://s3-us-west-2.amazonaws.com/voc-data/VOCtest_06-Nov-2007.tar

#Copy to HDFS
$HADOOP_HOME/bin/hadoop fs -copyFromLocal VOCtrainval_06-Nov-2007.tar $HDFS_DIR
$HADOOP_HOME/bin/hadoop fs -copyFromLocal VOCtest_06-Nov-2007.tar $HDFS_DIR