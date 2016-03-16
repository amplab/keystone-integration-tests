#!/bin/bash

if [ -z ${HADOOP_HOME+x} ]; then
    echo "HADOOP_HOME must be set"
    exit 1
fi

if [ -z ${HDFS_PATH+x} ]; then
    echo "HDFS_PATH must be set"
    exit 1
fi

if [ -z ${LOCAL_PATH+x} ]; then
    echo "LOCAL_PATH must be set"
    exit 1
fi

#CIFAR Data

#Get the data
wget http://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz

#Decompress it
tar zxvf cifar-10-binary.tar.gz
cat cifar-10-batches-bin/data_batch*.bin > $LOCAL_PATH/cifar_train.bin
mv cifar-10-batches-bin/test_batch.bin $LOCAL_PATH/cifar_test.bin

#VOC Data

#Get the data
wget https://s3-us-west-2.amazonaws.com/voc-data/VOCtrainval_06-Nov-2007.tar
wget https://s3-us-west-2.amazonaws.com/voc-data/VOCtest_06-Nov-2007.tar

#Copy to HDFS
$HADOOP_HOME/bin/hadoop fs -copyFromLocal VOCtrainval_06-Nov-2007.tar $HDFS_PATH
$HADOOP_HOME/bin/hadoop fs -copyFromLocal VOCtest_06-Nov-2007.tar $HDFS_PATH

#Newsgroups Data
#Get the data
wget http://qwone.com/~jason/20Newsgroups/20news-bydate.tar.gz
tar zxvf 20news-bydate.tar.gz

$HADOOP_HOME/bin/hadoop fs -copyFromLocal 20news-bydate-train $HDFS_PATH
$HADOOP_HOME/bin/hadoop fs -copyFromLocal 20news-bydate-test $HDFS_PATH
