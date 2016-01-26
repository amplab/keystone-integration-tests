#!/bin/bash

#CIFAR Data

#Get the data
wget http://www.cs.toronto.edu/~kriz/cifar-10-binary.tar.gz

#Decompress it
tar zxvf cifar-10-binary.tar.gz
cat cifar-10-batches-bin/data_batch*.bin > ./cifar_train.bin
mv cifar-10-batches-bin/test_batch.bin ./cifar_test.bin


#VOC Data

#Get the data
wget https://s3-us-west-2.amazonaws.com/voc-data/VOCtrainval_06-Nov-2007.tar
wget https://s3-us-west-2.amazonaws.com/voc-data/VOCtest_06-Nov-2007.tar

#Copy to HDFS
#Todo: Should not assume this is the hadoop location.
/root/ephemeral-hdfs/bin/hadoop fs -copyFromLocal VOCtrainval_06-Nov-2007.tar /data/
/root/ephemeral-hdfs/bin/hadoop fs -copyFromLocal VOCtest_06-Nov-2007.tar /data/