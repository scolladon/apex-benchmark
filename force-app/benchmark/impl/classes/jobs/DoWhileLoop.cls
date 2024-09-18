public class DoWhileLoop implements BenchmarkJob {
  private List<Integer> subject = new List<Integer>();

  public DoWhileLoop() {
    for (Integer i = 0; i < ForInteger.ELEMENT_SIZED; ++i) {
      this.subject.add(i);
    }
  }

  public void execute() {
    Integer i = 0;
    do {
      Integer result = this.subject[i++];
    } while (i < this.subject.size());
  }
}
