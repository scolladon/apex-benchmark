public class ClassNameValueOf implements BenchmarkJob {
  public void execute() {
    String.valueOf(this).substringBefore(':');
  }
}
