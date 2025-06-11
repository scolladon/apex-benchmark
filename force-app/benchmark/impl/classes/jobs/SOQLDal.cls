public class SOQLDal implements BenchmarkJob {
  public void execute() {
    final List<Opportunity> oppys = DAL.query([SELECT Id FROM Opportunity]);
    final Integer oppysSize = oppys.size();
    for (Integer i = 0; i < oppysSize; ++i) {
      final Opportunity opp = oppys[i];
      System.Debug(opp);
    }
  }
}
