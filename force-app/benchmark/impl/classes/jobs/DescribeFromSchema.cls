public class DescribeFromSchema implements BenchmarkJob {
  public void execute() {
    final DescribeSObjectResult describeResult = Account.SObjectType.getDescribe();
  }
}
