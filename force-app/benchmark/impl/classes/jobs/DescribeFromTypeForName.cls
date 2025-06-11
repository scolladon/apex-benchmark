public class DescribeFromTypeForName implements BenchmarkJob {
  public void execute() {
    final SObject aSob = (SObject) Type.forName('Account').newInstance();
    final DescribeSObjectResult describeResult = aSob.getSObjectType().getDescribe();
  }
}
