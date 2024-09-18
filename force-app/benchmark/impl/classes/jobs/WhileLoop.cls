public class WhileLoop implements BenchmarkJob {
  private List<Integer> subject = new List<Integer>();

  public WhileLoop() {
    for (Integer i = 0; i < ForInteger.ELEMENT_SIZED; ++i) {
      this.subject.add(i);
    }
  }

  public void execute() {
    Integer i = 0;
    while (i < this.subject.size()) {
      Integer result = this.subject[i++];
    }
  }
}
