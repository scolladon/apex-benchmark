public class BenchmarkResult {
  @AuraEnabled
  public List<StatMetrics> stats { get; private set; }

  @AuraEnabled
  public JobConf jobConf { get; private set; }

  public BenchmarkResult() {
    this.stats = new List<StatMetrics>();
  }

  public BenchmarkResult with(final StatMetrics metrics) {
    this.stats.add(metrics);
    return this;
  }

  public BenchmarkResult with(final JobConf jobConf) {
    this.jobConf = jobConf;
    return this;
  }
}
