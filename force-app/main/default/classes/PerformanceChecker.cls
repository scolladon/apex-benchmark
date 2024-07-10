public with sharing class PerformanceChecker {
  public static void doSomethingStatic() {
  }

  private class MyObject {
    public void doSomethingWithObject() {
    }
  }

  public abstract class MetricAggregator {
    private MetricValues values = new MetricValues();
    private String description;
    public abstract void setup();
    public abstract void capture();
    public MetricValues getValues() {
      return this.values;
    }
    public String getDescription() {
      return this.description;
    }
  }

  public class CPUTimeMetricAggregator extends MetricAggregator {
    private Integer startCpuTime;

    public CPUTimeMetricAggregator() {
      this.description = 'cpu time';
    }

    public override void setup() {
      this.startCpuTime = Limits.getCpuTime();
    }

    public override void capture() {
      Integer cpuTime = Limits.getCpuTime() - this.startCpuTime;
      this.values.addMetric(cpuTime);
    }
  }

  public class HeapSizeMetricAggregator extends MetricAggregator {
    private Integer startHeapSize;

    public HeapSizeMetricAggregator() {
      this.description = 'heap size';
    }

    public override void setup() {
      this.startHeapSize = Limits.getHeapSize();
    }

    public override void capture() {
      Integer heapSize = Limits.getHeapSize() - this.startHeapSize;
      this.values.addMetric(heapSize);
    }
  }

  public interface BenchmarkJob {
    void execute();
  }

  public class ObjectMethodJob implements BenchmarkJob {
    public void execute() {
      MyObject o = new MyObject();
      o.doSomethingWithObject();
    }
  }

  public class StaticMethodJob implements BenchmarkJob {
    public void execute() {
      PerformanceChecker.doSomethingStatic();
    }
  }

  public class BenchmarkRunner {
    private List<MetricAggregator> metricAggregators = new List<MetricAggregator>();
    private BenchmarkJob job;
    private Decimal threashold = 0.95;
    private Integer samplingSize = 50000;

    public BenchmarkRunner withMetricAggregator(MetricAggregator metricAggregator) {
      this.metricAggregators.add(metricAggregator);
      return this;
    }

    public BenchmarkRunner withSamplingSize(Integer samplingSize) {
      this.samplingSize = samplingSize;
      return this;
    }

    public BenchmarkRunner withJob(BenchmarkJob job) {
      this.job = job;
      return this;
    }

    public CalculationResult run() {
      while (Limits.getCpuTime() / Limits.getLimitCpuTime() < THREASHOLD) {
        for (MetricAggregator metricAggregator : this.metricAggregators) {
          metricAggregator.setup();
        }

        for (Integer i = 0; i < this.samplingSize; ++i) {
          this.job.execute();
        }

        for (MetricAggregator metricAggregator : this.metricAggregators) {
          metricAggregator.capture();
        }
      }

      CalculationResult result = new CalculationResult();
      for (MetricAggregator metricAggregator : this.metricAggregators) {
        result.withStat(new StatMetricBuilder().withAggregator(metricAggregator).build());
      }
      return result;
    }
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

  @AuraEnabled
  public static CalculationResult staticPerformance(Integer iteration) {
    return new BenchmarkRunner()
      .withSamplingSize(iteration)
      .withMetricAggregator(new HeapSizeMetricAggregator())
      .withMetricAggregator(new CPUTimeMetricAggregator())
      .withJob(new StaticMethodJob())
      .run();
  }

  @AuraEnabled
  public static CalculationResult objectPerformance(Integer iteration) {
    return new BenchmarkRunner()
      .withSamplingSize(iteration)
      .withMetricAggregator(new HeapSizeMetricAggregator())
      .withMetricAggregator(new CPUTimeMetricAggregator())
      .withJob(new ObjectMethodJob())
      .run();
  }

  public class StatMetricBuilder {
    private List<Integer> datas;
    private String description;

    public StatMetricBuilder withAggregator(final MetricAggregator aggregator) {
      this.datas = aggregator.getValues().getValues();
      this.description = aggregator.getDescription();
      this.datas.sort();
      return this;
    }
    public StatMetrics build() {
      return new StatMetrics(this);
    }

    public String getDescription() {
      return this.description;
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

  public class StatMetrics {
    @AuraEnabled
    public String description;

    @AuraEnabled
    public Integer max;

    @AuraEnabled
    public Integer min;

    @AuraEnabled
    public Double mean;

    @AuraEnabled
    public Integer median;

    @AuraEnabled
    public Decimal deviation;

    @AuraEnabled
    public Decimal variance;

    public StatMetrics(StatMetricBuilder calculator) {
      this.description = calculator.getDescription();
      this.max = calculator.getMax();
      this.min = calculator.getMin();
      this.mean = calculator.getMean();
      this.median = calculator.getMedian();
      this.deviation = calculator.getDeviation();
      this.variance = calculator.getVariance();
    }
  }

  public class CalculationResult {
    @AuraEnabled
    public List<StatMetrics> stats;

    public CalculationResult() {
      this.stats = new List<StatMetrics>();
    }

    public CalculationResult withStat(StatMetrics metrics) {
      this.stats.add(metrics);
      return this;
    }
  }
}
