public with sharing class StringIndexOf implements BenchmarkJob {
  private String subject = '';

  public StringIndexOf() {
    for (Integer i = 0; i < 3000; i++) {
      subject += ';String reasonably long ' + i + ';';
    }
  }

  public void execute() {
    this.subject.contains(';not foundable;');
  }
}
