public class CPUTimeProfiler extends BaseProfiler {
  private Integer startCpuTime;

  public CPUTimeProfiler() {
    this.description = 'cpu time';
    this.metric = 'ms';
  }

  public override void setup() {
    this.startCpuTime = Limits.getCpuTime();
  }

  public override void capture() {
    Integer cpuTime = Limits.getCpuTime() - this.startCpuTime;
    this.values.addMetric(cpuTime);
  }
}
