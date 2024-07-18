public class HeapSizeProfiler extends BaseProfiler {
  private Integer startHeapSize;

  public HeapSizeProfiler() {
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
