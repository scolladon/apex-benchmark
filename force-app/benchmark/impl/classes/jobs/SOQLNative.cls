public class SOQLNative implements BenchmarkJob {
  public void execute() {
    for (Opportunity opp : [SELECT Id FROM Opportunity]) {
      System.Debug(opp);
    }
  }
}
