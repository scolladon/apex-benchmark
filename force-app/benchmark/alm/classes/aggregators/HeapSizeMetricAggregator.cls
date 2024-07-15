public class HeapSizeMetricAggregator extends BaseMetricAggregator {
  private Integer startHeapSize;

  public HeapSizeMetricAggregator() {
    this.description = 'heap size';
    this.metric = 'bytes';
  }

  public override void setup() {
    this.startHeapSize = Limits.getHeapSize();
  }

  public override void capture() {
    Integer heapSize = Limits.getHeapSize() - this.startHeapSize;
    this.values.addMetric(heapSize);
  }
}
