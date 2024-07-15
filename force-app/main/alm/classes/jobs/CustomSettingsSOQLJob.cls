public class CustomSettingsSOQLJob implements BenchmarkJob {
  public void execute() {
    List<SObject> a = [SELECT Name, Value__c FROM PerfTest__c WHERE NAME = 'PerfTest'];
  }
}
