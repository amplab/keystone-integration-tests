package tests

import org.apache.spark.SparkContext
import pipelines.images.cifar.RandomPatchCifar
import pipelines.images.cifar.RandomPatchCifar.RandomCifarConfig
import pipelines.images.voc.VOCSIFTFisher
import pipelines.images.voc.VOCSIFTFisher.SIFTFisherConfig
import pipelines.text.NewsgroupsPipeline
import pipelines.text.NewsgroupsPipeline.NewsgroupsConfig

object IntegrationTests {
  val baseDir = System.getenv("HDFS_PATH")

  val cifar = RandomPatchCifar.run(_: SparkContext,
    RandomCifarConfig(
      trainLocation=s"$baseDir/cifar_train.bin",
      testLocation=s"$baseDir/cifar_test.bin",
      numFilters=1000,
      lambda=Some(3000.0)
    )
  )

  val voc = VOCSIFTFisher.run(_: SparkContext,
    SIFTFisherConfig(
      trainLocation=s"$baseDir/VOCtrainval_06-Nov-2007.tar",
      testLocation=s"$baseDir/VOCtest_06-Nov-2007.tar",
      labelPath=s"${System.getenv("KEYSTONE_DIR")}/src/test/resources/images/voclabels.csv",
      numParts=200
    )
  )

  val newsgroups = NewsgroupsPipeline.run(_: SparkContext,
    NewsgroupsConfig(
      trainLocation=s"$baseDir/20news-bydate-train",
      testLocation=s"$baseDir/20news-bydate-test"
    )
  )
}