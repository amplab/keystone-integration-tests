import org.apache.spark.{SparkConf, SparkContext}
import pipelines.Logging
import tests.IntegrationTests._

object TestRunner extends Logging {
  def main(args: Array[String]) = {
    val testName = if (args.length < 1) "all" else args(0)

    val sc = new SparkContext(new SparkConf().setAppName(s"TestRunner($testName)"))

    val runs = testName match {
      case "all" => tests.keys
      case _ => Seq(testName)
    }

    val results = runs.map(t => (t, tests(t)(sc)))

    results.foreach(s => logInfo(s.toString))

    sc.stop()

  }
}

