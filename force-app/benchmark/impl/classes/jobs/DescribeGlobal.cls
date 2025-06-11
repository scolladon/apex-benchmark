public class DescribeGlobal implements BenchmarkJob {
  Map<String, SObjectType> types = Schema.getGlobalDescribe();
  public void execute() {
    final DescribeSObjectResult describeResult = types.get('Account').getDescribe(); 
  }
}
