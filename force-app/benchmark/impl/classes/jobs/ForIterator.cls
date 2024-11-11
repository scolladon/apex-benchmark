public class ForIterator implements BenchmarkJob {
  public static Integer ELEMENT_SIZED = 10000;
  private List<Integer> subject = new List<Integer>();

  public ForIterator() {
    for (Integer i = 0; i < ForInteger.ELEMENT_SIZED; ++i) {
      this.subject.add(i);
    }
  }

  public void execute() {
    Iterator<Integer> iterator = this.subject.iterator();
    while (iterator.hasNext()) {
      Integer value = iterator.next();
    }
  }
}
