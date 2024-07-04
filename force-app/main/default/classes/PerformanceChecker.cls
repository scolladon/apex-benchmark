public with sharing class PerformanceChecker {
  private static Double THREASHOLD = 0.95;

  public static void doSomethingStatic() {
  }

  private class MyObject {
    public void doSomethingWithObject() {
    }
  }

  @AuraEnabled
  public static CalculationResult staticPerformance(Integer iteration) {
    List<Integer> cpuTimes = new List<Integer>();
    List<Integer> heapSizes = new List<Integer>();
    while (Limits.getCpuTime() / Limits.getLimitCpuTime() < THREASHOLD) {
      Integer startCpuTime = Limits.getCpuTime();
      Integer startHeapSize = Limits.getHeapSize();

      // Do something
      for (Integer i = 0; i < iteration; ++i) {
        doSomethingStatic();
      }

      Integer cpuTime = Limits.getCpuTime() - startCpuTime;
      Integer heapSize = Limits.getHeapSize() - startHeapSize;
      System.debug(LoggingLevel.WARN, 'PERF: Static method with ' + ITERATION + ' iterations took : ' + cpuTime + ' ms and ' + HeapSize + ' bytes');
      cpuTimes.add(cpuTime);
      heapSizes.add(heapSize);
    }

    StatCalculator cpu = new StatCalculator(cpuTimes);
    StatCalculator heap = new StatCalculator(heapSizes);
    return new CalculationResult(new StatMetrics(cpu), new StatMetrics(heap));
  }

  @AuraEnabled
  public static CalculationResult objectPerformance(Integer iteration) {
    List<Integer> cpuTimes = new List<Integer>();
    List<Integer> heapSizes = new List<Integer>();
    while (Limits.getCpuTime() / Limits.getLimitCpuTime() < THREASHOLD) {
      Integer startCpuTime = Limits.getCpuTime();
      Integer startHeapSize = Limits.getHeapSize();

      // Do something
      for (Integer i = 0; i < iteration; ++i) {
        MyObject myObject = new MyObject();
        myObject.doSomethingWithObject();
      }

      Integer cpuTime = Limits.getCpuTime() - startCpuTime;
      Integer heapSize = Limits.getHeapSize() - startHeapSize;
      System.debug(LoggingLevel.WARN, 'PERF: Object method with ' + ITERATION + ' iterations took : ' + cpuTime + ' ms and ' + HeapSize + ' bytes');
      cpuTimes.add(cpuTime);
      heapSizes.add(heapSize);
    }

    StatCalculator cpu = new StatCalculator(cpuTimes);
    StatCalculator heap = new StatCalculator(heapSizes);
    return new CalculationResult(new StatMetrics(cpu), new StatMetrics(heap));
  }

  public class StatCalculator {
    private List<Integer> datas;
    public StatCalculator(final List<Integer> datas) {
      this.datas = datas;
      this.datas.sort();
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
  }

  public class StatMetrics {
    @AuraEnabled
    public Integer max;

    @AuraEnabled
    public Integer min;

    @AuraEnabled
    public Double mean;

    @AuraEnabled
    public Integer median;

    public StatMetrics(StatCalculator calculator) {
      this.max = calculator.getMax();
      this.min = calculator.getMin();
      this.mean = calculator.getMean();
      this.median = calculator.getMedian();
    }
  }

  public class CalculationResult {
    @AuraEnabled
    public StatMetrics cpuMetrics;
    @AuraEnabled
    public StatMetrics heapSizeMetrics;

    public CalculationResult(StatMetrics cpuMetrics, StatMetrics heapSizeMetrics) {
      this.cpuMetrics = cpuMetrics;
      this.heapSizeMetrics = heapSizeMetrics;
    }
  }
}
