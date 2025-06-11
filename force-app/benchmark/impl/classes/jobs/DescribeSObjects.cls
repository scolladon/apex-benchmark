public class DescribeSObjects implements BenchmarkJob {
  public void execute() {
    final DescribeSObjectResult describeResult = Schema.describeSObjects(new List<String> { 'Account' })[0];
  }
}
