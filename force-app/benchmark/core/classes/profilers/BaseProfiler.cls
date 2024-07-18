public abstract class BaseProfiler implements Profiler {
  protected MetricValues values = new MetricValues();
  protected String description;
  protected String metric;
  public abstract void setup();
  public abstract void capture();
  public List<Integer> getValues() {
    return this.values.getValues();
  }
  public String getDescription() {
    return this.description;
  }
  public String getMetric() {
    return this.metric;
  }

  public class MetricValues {
    private List<Integer> values = new List<Integer>();

    public void addMetric(Integer value) {
      this.values.add(value);
    }

    public List<Integer> getValues() {
      return this.values;
    }
  }
}
