public class ObjectMethodJob implements BenchmarkJob {
  private class MyObject {
    public void doSomethingWithObject() {
    }
  }

  public void execute() {
    MyObject o = new MyObject();
    o.doSomethingWithObject();
  }
}
