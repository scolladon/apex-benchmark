public class RecordTypeSOQL implements BenchmarkJob {
  public void execute() {
    final List<Opportunity> oppys = [SELECT Account.Name, RecordType.DeveloperName FROM Opportunity];
  }
}
