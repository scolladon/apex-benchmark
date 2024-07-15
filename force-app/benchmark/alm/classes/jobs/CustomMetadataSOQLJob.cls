public class CustomMetadataSOQLJob implements BenchmarkJob {
  public void execute() {
    List<SObject> a = [SELECT MasterLabel, Value__c FROM PerfTestCMDT__mdt WHERE MasterLabel = 'PerfTest'];
  }
}
