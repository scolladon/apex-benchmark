public class StringReplaceAll implements BenchmarkJob {
  String bigInput = '&lt;I don\'t see any problem splitting like crazy&gt;'.repeat(4000);

  public void execute() {
    bigInput.replaceAll('&lt;', '<');
  }
}
