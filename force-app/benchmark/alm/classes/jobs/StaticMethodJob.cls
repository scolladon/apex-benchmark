public class StaticMethodJob implements BenchmarkJob {
  public static void doSomethingStatic() {
  }
  public void execute() {
    StaticMethodJob.doSomethingStatic();
  }
}
