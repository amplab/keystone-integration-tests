package tests

import breeze.linalg.DenseVector
import breeze.stats._
import evaluation.{MeanAveragePrecisionEvaluator, MulticlassClassifierEvaluator}
import loaders._
import nodes.images.{MultiLabelExtractor, MultiLabeledImageExtractor}
import org.apache.spark.SparkContext
import pipelines.images.cifar.RandomPatchCifar
import pipelines.images.cifar.RandomPatchCifar.RandomCifarConfig
import pipelines.images.voc.VOCSIFTFisher
import pipelines.images.voc.VOCSIFTFisher.SIFTFisherConfig
import pipelines.text.NewsgroupsPipeline
import pipelines.text.NewsgroupsPipeline.NewsgroupsConfig
import utils.Image
import workflow.Pipeline

case class TestResult(seconds: Double, score: Double)

object IntegrationTests {
  val baseDir = System.getenv("HDFS_PATH")
  val localDir= System.getenv("LOCAL_PATH")

  val tests: Map[String, SparkContext => TestResult] = Map("cifar" -> cifar,
    "voc" -> voc,
    "newsgroups" -> newsgroups)

  def time[R](block: => R): (R, Double) = {
    val t0 = System.nanoTime()
    val result = block
    val elapsed = System.nanoTime() - t0
    (result, elapsed/1e6)
  }

  def cifar(sc: SparkContext): TestResult = {
    val conf = RandomCifarConfig(
      trainLocation=s"$localDir/cifar_train.bin",
      testLocation = s"$localDir/cifar_test.bin",
      numFilters=1000,
      lambda=Some(3000.0)
    )

    val (pipe, timing) = time(RandomPatchCifar.run(sc, conf).asInstanceOf[Pipeline[Image,Int]])

    val testData = CifarLoader(sc, conf.testLocation)
    val result = MulticlassClassifierEvaluator(pipe(testData.map(_.image)), testData.map(_.label), 10)

    TestResult(timing, result.totalError)
  }

  def voc(sc: SparkContext): TestResult = {
    val conf = SIFTFisherConfig(
      trainLocation=s"$baseDir/VOCtrainval_06-Nov-2007.tar",
      testLocation = s"$baseDir/VOCtest_06-Nov-2007.tar",
      labelPath = s"${System.getenv("KEYSTONE_DIR")}/src/test/resources/images/voclabels.csv",
      numParts=200
    )

    val (pipe, timing) = time(VOCSIFTFisher.run(sc: SparkContext, conf).asInstanceOf[Pipeline[Image,DenseVector[Double]]])

    val testData = VOCLoader(sc,
        VOCDataPath(conf.testLocation, "VOCdevkit/VOC2007/JPEGImages/", Some(1)),
        VOCLabelPath(conf.labelPath)).repartition(conf.numParts)

    val result = MeanAveragePrecisionEvaluator(
      MultiLabelExtractor(testData),
      pipe(MultiLabeledImageExtractor(testData)),
      VOCLoader.NUM_CLASSES)

    val map = mean(result)

    TestResult(timing, map)
  }

  def newsgroups(sc: SparkContext): TestResult = {
    val conf = NewsgroupsConfig(
      trainLocation=s"$baseDir/20news-bydate-train",
      testLocation=s"$baseDir/20news-bydate-test"
    )

    val (pipe, timing) = time(NewsgroupsPipeline.run(sc: SparkContext, conf).asInstanceOf[Pipeline[String, Int]])

    val numClasses = 20
    val testData = NewsgroupsDataLoader(sc, conf.testLocation)
    val result = MulticlassClassifierEvaluator(pipe(testData.data), testData.labels, numClasses)

    TestResult(timing, result.macroFScore())
  }
}
