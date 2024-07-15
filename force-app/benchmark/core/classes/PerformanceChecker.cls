public class PerformanceChecker {
  @AuraEnabled(cacheable=true)
  public static List<JobType> getBenchmarkRegistry() {
    BenchmarkFactory factory = new BenchmarkFactory();
    return factory.listAvailableJobs();
  }

  @AuraEnabled(cacheable=true)
  public static List<MetricType> getMetricRegistry() {
    BenchmarkFactory factory = new BenchmarkFactory();
    return factory.listAvailableMetrics();
  }

  @AuraEnabled
  public static BenchmarkResult runBenchmark(JobConf jobConf) {
    System.debug(jobConf);
    return new BenchmarkRunner().with(jobConf).run();
  }
}
