public with sharing class PerformanceChecker {
  public abstract class MetricAggregator {
    private MetricValues values = new MetricValues();
    private String description;
    private String metric;
    public abstract void setup();
    public abstract void capture();
    public MetricValues getValues() {
      return this.values;
    }
    public String getDescription() {
      return this.description;
    }
    public String getMetric() {
      return this.metric;
    }
  }

  public class CPUTimeMetricAggregator extends MetricAggregator {
    private Integer startCpuTime;

    public CPUTimeMetricAggregator() {
      this.description = 'cpu time';
      this.metric = 'ms';
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

  public class BenchmarkRunner {
    private List<MetricAggregator> metricAggregators = new List<MetricAggregator>();
    private BenchmarkJob job;
    private Decimal threashold = 0.95;
    private BenchmarkModel.JobConf jobConf;
    private BenchmarkFactory benchmarkFactory;

    @testVisible
    private BenchmarkRunner(BenchmarkFactory benchmarkFactory) {
      this.benchmarkFactory = benchmarkFactory;
    }

    private BenchmarkRunner() {
      this(new BenchmarkFactory());
    }

    public BenchmarkRunner with(MetricAggregator metricAggregator) {
      this.metricAggregators.add(metricAggregator);
      return this;
    }

    public BenchmarkRunner with(BenchmarkModel.JobConf jobConf) {
      this.jobConf = jobConf;
      return this;
    }

    public BenchmarkResult run() {
      final BenchmarkJob job = this.benchmarkFactory.getSubject(this.jobConf.jobType);
      final Integer samplingSize = this.jobConf.samplingSize ?? 50000;
      while (Limits.getCpuTime() / Limits.getLimitCpuTime() < THREASHOLD) {
        for (MetricAggregator metricAggregator : this.metricAggregators) {
          metricAggregator.setup();
        }

        for (Integer i = 0; i < samplingSize; ++i) {
          job.execute();
        }

        for (MetricAggregator metricAggregator : this.metricAggregators) {
          metricAggregator.capture();
        }
      }

      BenchmarkResult result = new BenchmarkResult().with(this.jobConf);
      for (MetricAggregator metricAggregator : this.metricAggregators) {
        result.with(new StatMetricBuilder().with(metricAggregator).build());
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

  @AuraEnabled(cacheable=true)
  public static List<BenchmarkModel.JobType> getBenchmarkRegistry() {
    BenchmarkFactory factory = new BenchmarkFactory();
    return factory.listAvailableJobs();
  }

  @AuraEnabled
  public static BenchmarkResult runBenchmark(BenchmarkModel.JobConf jobConf) {
    return new BenchmarkRunner().with(jobConf).with(new HeapSizeMetricAggregator()).with(new CPUTimeMetricAggregator()).run();
  }

  public class StatMetricBuilder {
    private List<Integer> datas;
    private MetricAggregator metricAggregator;
    private String metric;

    public StatMetricBuilder with(final MetricAggregator aggregator) {
      this.datas = aggregator.getValues().getValues();
      this.metricAggregator = aggregator;
      this.datas.sort();
      return this;
    }
    public StatMetrics build() {
      return new StatMetrics(this);
    }

    public String getDescription() {
      return this.metricAggregator.getDescription();
    }

    public String getMetric() {
      return this.metricAggregator.getMetric();
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
    public String metric;

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
      this.metric = calculator.getMetric();
      this.max = calculator.getMax();
      this.min = calculator.getMin();
      this.mean = calculator.getMean();
      this.median = calculator.getMedian();
      this.deviation = calculator.getDeviation();
      this.variance = calculator.getVariance();
    }
  }

  public class BenchmarkResult {
    @AuraEnabled
    public List<StatMetrics> stats { get; private set; }

    @AuraEnabled
    public BenchmarkModel.JobConf jobConf { get; private set; }

    public BenchmarkResult() {
      this.stats = new List<StatMetrics>();
    }

    public BenchmarkResult with(StatMetrics metrics) {
      this.stats.add(metrics);
      return this;
    }

    public BenchmarkResult with(BenchmarkModel.JobConf jobConf) {
      this.jobConf = jobConf;
      return this;
    }
  }
}
