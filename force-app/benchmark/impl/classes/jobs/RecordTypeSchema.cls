public class RecordTypeSchema implements BenchmarkJob {

  public void execute() {
    final List<Opportunity> oppys = [SELECT Account.Name FROM Opportunity];
    final Map<String, RecordTypeInfo> recordTypes = Opportunity.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName();
  }
}
