public class DescribeFromSObjectType implements BenchmarkJob {
  private SObjectType sObjecType = Account.SObjectType;

  public void execute() {
    final DescribeSObjectResult describeResult = sObjecType.getDescribe();
  }
}
