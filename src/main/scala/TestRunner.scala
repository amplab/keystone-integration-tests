import org.apache.spark.{SparkConf, SparkContext}
import pipelines.Logging
import tests.IntegrationTests._

object TestRunner extends Logging {
  def main(args: Array[String]) = {
    val testName = if (args.length < 1) "all" else args(0)

    val sc = new SparkContext(new SparkConf().setAppName("TestRunner: " + testName))

    val tests = Map(
      "cifar" -> cifar,
      "voc" -> voc,
      "newsgroups" -> newsgroups
    )

    val runs = testName match {
      case "all" => tests.keys
      case _ => Seq(testName)
    }

    runs.foreach(t => {
      logInfo(s"Running test $t")
      val start = System.currentTimeMillis()
      tests(t)(sc)
      val diff = System.currentTimeMillis() - start
      logInfo(s"Finished test $t in $diff")
    })

    sc.stop()

  }
}

