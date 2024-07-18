public interface Profiler {
  List<Integer> getValues();
  String getDescription();
  String getMetric();
  void setup();
  void capture();
}
