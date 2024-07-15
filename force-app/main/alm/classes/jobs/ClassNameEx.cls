public class ClassNameEx implements BenchmarkJob {
  public void execute() {
    getClassName(new DmlException());
  }

  public static String getClassName(Exception ex) {
    List<String> parts = ex.getStackTraceString().substringBefore(':').split('\\.');
    return parts[parts.size() - 2];
  }
}
