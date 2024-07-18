public class CustomMetadataApexJob implements BenchmarkJob {
  public void execute() {
    PerfTestCMDT__mdt.getInstance('PerfTest');
  }
}
