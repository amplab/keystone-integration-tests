# keystone-integration-tests
Integration Tests for KeystoneML

To run: 

```
./bin/run master
```

Where `master` is the branch of KeystoneML to be cloned. This argument will be passed to `git`'s `--single-branch` option when cloning the repository.

Currently, the code in this repository only works on the AMP local spark cluster, but it should be easy to get it to work with other YARN Spark Clusters.
