package tests

import org.apache.spark.SparkContext
import pipelines.images.cifar.RandomPatchCifar
import pipelines.images.cifar.RandomPatchCifar.RandomCifarConfig
import pipelines.images.voc.VOCSIFTFisher
import pipelines.images.voc.VOCSIFTFisher.SIFTFisherConfig
import pipelines.text.NewsgroupsPipeline
import pipelines.text.NewsgroupsPipeline.NewsgroupsConfig

object IntegrationTests {
  val cifar = RandomPatchCifar.run(_: SparkContext,
    RandomCifarConfig(
      trainLocation="./cifar_train.bin",
      testLocation="./cifar_test.bin",
      numFilters=1000,
      lambda=Some(3000.0)
    )
  )

  val voc = VOCSIFTFisher.run(_: SparkContext,
    SIFTFisherConfig(
      trainLocation="/data/VOCtrainval_06-Nov-2007.tar",
      testLocation="/data/VOCtest_06-Nov-2007.tar",
      labelPath=s"${System.getenv("KEYSTONE_DIR")}/src/test/resources/images/voclabels.csv",
      numParts=200
    )
  )

  val newsgroups = NewsgroupsPipeline.run(_: SparkContext,
    NewsgroupsConfig(
      trainLocation="/data/20news-bydate-train",
      testLocation="/data/20news-bydate-test"
    )
  )
}