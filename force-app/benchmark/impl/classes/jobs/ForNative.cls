public class ForNative implements BenchmarkJob {
  private List<Integer> subject = new List<Integer>();

  public ForNative() {
    for (Integer i = 0; i < ForInteger.ELEMENT_SIZED; ++i) {
      this.subject.add(i);
    }
  }

  public void execute() {
    for (Integer i : subject) {
      Integer result = i;
    }
  }
}
