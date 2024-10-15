public with sharing class StringSetContains implements BenchmarkJob {
  private Set<String> subject = new Set<String>();

  public StringSetContains() {
    for (Integer i = 0; i < 3000; i++) {
      this.subject.add('String reasonably long ' + i);
    }
  }

  public void execute() {
    this.subject.contains('not foundable');
  }
}
