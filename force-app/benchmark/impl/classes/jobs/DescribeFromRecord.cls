public class DescribeFromRecord implements BenchmarkJob {
  Account record = new Account();
  public void execute() {
    final DescribeSObjectResult describeResult = record.getSObjectType().getDescribe();
  }
}
