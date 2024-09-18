public class ForIntegerReverse implements BenchmarkJob {
  private List<Integer> subject = new List<Integer>();

  public ForIntegerReverse() {
    for (Integer i = 0; i < ForInteger.ELEMENT_SIZED; ++i) {
      this.subject.add(i);
    }
  }

  public void execute() {
    for (Integer i = this.subject.size() - 1; i >= 0; --i) {
      Integer result = this.subject[i];
    }
  }
}
