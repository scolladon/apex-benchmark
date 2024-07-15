public class CustomSettingsApexJob implements BenchmarkJob {
  public void execute() {
    PerfTest__c.getInstance('PerfTest');
  }
}
