public class BenchmarkRunner {
  private List<Profiler> profilers = new List<Profiler>();
  private BenchmarkJob job;
  private JobConf jobConf;
  private BenchmarkFactory benchmarkFactory;

  private static final Integer MAX_DEFAULT_SAMPLING_SIZE = 50000;

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

    this.setSamplingSize(job);

    TransactionChecker checker = new TransactionChecker();
    while (checker.canRun()) {
      checker.prepare();
      for (Profiler Profiler : this.profilers) {
        Profiler.setup();
      }

      for (Integer i = 0; i < this.jobConf.samplingSize; ++i) {
        job.execute();
      }

      for (Profiler Profiler : this.profilers) {
        Profiler.capture();
      }
      checker.record();
    }

    BenchmarkResult result = new BenchmarkResult().with(this.jobConf);
    for (Profiler Profiler : this.profilers) {
      result.with(new StatMetricBuilder().with(Profiler).build());
    }
    return result;
  }

  private void setSamplingSize(final BenchmarkJob job) {
    Integer unitCpuTimeConsumptionEstimate = Limits.getCpuTime();
    job.execute();
    unitCpuTimeConsumptionEstimate = Limits.getCpuTime() - unitCpuTimeConsumptionEstimate;
    unitCpuTimeConsumptionEstimate = unitCpuTimeConsumptionEstimate == 0 ? 1 : unitCpuTimeConsumptionEstimate;
    this.jobConf.samplingSize = Math.min(getRemainingCPUTime() / unitCpuTimeConsumptionEstimate, this.jobConf.samplingSize ?? MAX_DEFAULT_SAMPLING_SIZE).intValue();
  }

  private static Decimal getRemainingCPUTime() {
    return (Limits.getLimitCpuTime() - Limits.getCpuTime()) * 0.95;
  }

  private class TransactionChecker {
    private Integer maxCPUConsumption = 0;

    private Integer currentCPUConsumption;

    private boolean canRun() {
      return this.maxCPUConsumption < getRemainingCPUTime();
    }

    public void prepare() {
      this.currentCPUConsumption = Limits.getCpuTime();
    }

    public void record() {
      this.currentCPUConsumption = Limits.getCpuTime() - this.currentCPUConsumption;
      if (this.currentCPUConsumption > maxCPUConsumption) {
        this.maxCPUConsumption = this.currentCPUConsumption;
      }
    }
  }
}
