public class ForIntegerSizeVariable implements BenchmarkJob {
  public static Integer ELEMENT_SIZED = 10000;
  private List<Integer> subject = new List<Integer>();

  public ForIntegerSizeVariable() {
    for (Integer i = 0; i < ForInteger.ELEMENT_SIZED; ++i) {
      this.subject.add(i);
    }
  }

  public void execute() {
    final Integer listLength = this.subject.size();
    for (Integer i = 0; i < listLength; ++i) {
      Integer result = this.subject[i];
    }
  }
}
