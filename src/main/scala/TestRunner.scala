package pipelines

import org.apache.spark.{SparkConf, SparkContext}
import pipelines.Logging
import tests.IntegrationTests._

object TestRunner extends Logging {
  def main(args: Array[String]) = {
    val testName = if (args.length < 1) "all" else args(0)
    val conf = new SparkConf()
    conf.setAppName(s"TestRunner($testName)")
    conf.remove("spark.jars")
    val sc = new SparkContext(conf)

    val runs = testName match {
      case "all" => tests.keys
      case _ => Seq(testName)
    }

    val results = runs.map(t => (t, tests(t)(sc)))

    for (r <- results) {
      println(s"$r")
    }

    sc.stop()

  }
}

