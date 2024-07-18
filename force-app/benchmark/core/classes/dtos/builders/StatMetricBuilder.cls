public class StatMetricBuilder {
  private List<Integer> datas;
  private Profiler Profiler;
  private String metric;

  public StatMetricBuilder with(final Profiler aggregator) {
    this.datas = aggregator.getValues();
    this.Profiler = aggregator;
    this.datas.sort();
    return this;
  }
  public StatMetrics build() {
    return new StatMetrics(this);
  }

  public String getDescription() {
    return this.Profiler.getDescription();
  }

  public String getMetric() {
    return this.Profiler.getMetric();
  }

  public Integer getMin() {
    return this.datas[0];
  }

  public Integer getMax() {
    return this.datas[this.datas.size() - 1];
  }

  public Double getMean() {
    Integer total = 0;

    for (Integer i : this.datas) {
      total += i;
    }

    return Double.valueOf(total) / this.datas.size();
  }

  public Integer getMedian() {
    Integer mid = this.datas.size() / 2;

    return this.datas[mid];
  }

  public Decimal getDeviation() {
    return Math.sqrt(this.getVariance());
  }

  public Decimal getVariance() {
    Decimal m = this.getMean();
    Decimal sum = 0.0;
    for (Integer x : this.datas) {
      sum += (x - m).pow(2);
    }
    return sum / this.datas.size();
  }
}
