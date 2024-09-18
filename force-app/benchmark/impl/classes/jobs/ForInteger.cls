public class ForInteger implements BenchmarkJob {
  public static Integer ELEMENT_SIZED = 10000;
  private List<Integer> subject = new List<Integer>();

  public ForInteger() {
    for (Integer i = 0; i < ForInteger.ELEMENT_SIZED; ++i) {
      this.subject.add(i);
    }
  }

  public void execute() {
    for (Integer i = 0; i < this.subject.size(); ++i) {
      Integer result = this.subject[i];
    }
  }
}
