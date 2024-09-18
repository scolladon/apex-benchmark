public class StringEqualsMethod implements BenchmarkJob {
  public void execute() {
    Boolean eq = 'TesT'.equalsIgnoreCase('test');
  }
}
