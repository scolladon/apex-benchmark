public class BenchmarkRunner {
  private List<Profiler> profilers = new List<Profiler>();
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
      this.profilers.add(this.benchmarkFactory.getAggregator(metric));
    }

    final Integer samplingSize = this.jobConf.samplingSize ?? 50000;
    while (Limits.getCpuTime() / Limits.getLimitCpuTime() < THREASHOLD) {
      for (Profiler Profiler : this.profilers) {
        Profiler.setup();
      }

      for (Integer i = 0; i < samplingSize; ++i) {
        job.execute();
      }

      for (Profiler Profiler : this.profilers) {
        Profiler.capture();
      }
    }

    BenchmarkResult result = new BenchmarkResult().with(this.jobConf);
    for (Profiler Profiler : this.profilers) {
      result.with(new StatMetricBuilder().with(Profiler).build());
    }
    return result;
  }
}
