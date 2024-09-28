public class BenchmarkRunner {
  private List<Profiler> profilers = new List<Profiler>();
  private BenchmarkJob job;
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

    Integer unitCpuTimeConsumptionEstimate = Limits.getCpuTime();
    job.execute();
    unitCpuTimeConsumptionEstimate = Limits.getCpuTime() - unitCpuTimeConsumptionEstimate;
    this.jobConf.samplingSize = Math.min(this.getRemainingCPUTime() / unitCpuTimeConsumptionEstimate, this.jobConf.samplingSize ?? 50000).intValue();

    Integer iterationCount = 0;
    while (maxCPUConsumption < this.getRemainingCPUTime()) {
      Integer currentCPUTimeConsumption = Limits.getCpuTime();
      for (Profiler Profiler : this.profilers) {
        Profiler.setup();
      }

      for (Integer i = 0; i < this.jobConf.samplingSize; ++i) {
        job.execute();
      }

      for (Profiler Profiler : this.profilers) {
        Profiler.capture();
      }
      currentCPUTimeConsumption = Limits.getCpuTime() - currentCPUTimeConsumption;
      if (currentCPUTimeConsumption > maxCPUConsumption) {
        maxCPUConsumption = currentCPUTimeConsumption;
      }
      ++iterationCount;
    }

    BenchmarkResult result = new BenchmarkResult().with(this.jobConf).with(iterationCount);
    for (Profiler Profiler : this.profilers) {
      result.with(new StatMetricBuilder().with(Profiler).build());
    }
    return result;
  }

  private Decimal getRemainingCPUTime() {
    return (Limits.getLimitCpuTime() - Limits.getCpuTime()) * 0.95;
  }
}
