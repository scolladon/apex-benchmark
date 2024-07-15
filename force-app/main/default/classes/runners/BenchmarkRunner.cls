public class BenchmarkRunner {
  private List<MetricAggregator> metricAggregators = new List<MetricAggregator>();
  private BenchmarkJob job;
  private Decimal threashold = 0.95;
  private JobConf jobConf;
  private BenchmarkFactory benchmarkFactory;

  @testVisible
  private BenchmarkRunner(BenchmarkFactory benchmarkFactory) {
    this.benchmarkFactory = benchmarkFactory;
  }

  public BenchmarkRunner() {
    this(new BenchmarkFactory());
  }

  public BenchmarkRunner with(JobConf jobConf) {
    this.jobConf = jobConf;
    return this;
  }

  public BenchmarkResult run() {
    final BenchmarkJob job = this.benchmarkFactory.getSubject(this.jobConf.jobType);

    for (MetricType metric : this.jobConf.metrics) {
      this.metricAggregators.add(this.benchmarkFactory.getAggregator(metric));
    }

    final Integer samplingSize = this.jobConf.samplingSize ?? 50000;
    while (Limits.getCpuTime() / Limits.getLimitCpuTime() < THREASHOLD) {
      for (MetricAggregator metricAggregator : this.metricAggregators) {
        metricAggregator.setup();
      }

      for (Integer i = 0; i < samplingSize; ++i) {
        job.execute();
      }

      for (MetricAggregator metricAggregator : this.metricAggregators) {
        metricAggregator.capture();
      }
    }

    BenchmarkResult result = new BenchmarkResult().with(this.jobConf);
    for (MetricAggregator metricAggregator : this.metricAggregators) {
      result.with(new StatMetricBuilder().with(metricAggregator).build());
    }
    return result;
  }
}
