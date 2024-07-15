public class DynamicLabelJob implements BenchmarkJob {
  public void execute() {
    System.Label.get('', 'PerfTest', '');
  }
}
