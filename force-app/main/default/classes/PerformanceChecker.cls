public with sharing class PerformanceChecker {
  private static Integer ITERATION = 10000;
  public static void doSomethingStatic() {
  }

  @AuraEnabled
  public static void staticPerformance() {
    List<Integer> cpuTimes = new List<Integer>();
    List<Integer> heapSizes = new List<Integer>();
    while (Limits.getCpuTime() / Limits.getLimitCpuTime() < 0.95) {
      Integer startCpuTime = Limits.getCpuTime();
      Integer startHeapSize = Limits.getHeapSize();

      // Do something
      for (Integer i = 0; i < ITERATION; ++i) {
        doSomethingStatic();
      }

      Integer cpuTime = Limits.getCpuTime() - startCpuTime;
      Integer heapSize = Limits.getHeapSize() - startHeapSize;
      //System.debug(LoggingLevel.WARN, 'PERF: Static method with ' + ITERATION + ' iterations took : ' + cpuTime + ' ms and ' + HeapSize + ' bytes');
      cpuTimes.add(cpuTime);
      heapSizes.add(heapSize);
    }

    Double avgCpuTime = getAverage(cpuTimes);
    Double avgHeapSize = getAverage(heapSizes);
    System.debug(LoggingLevel.WARN, 'PERF: Static method with ' + ITERATION + ' average iterations took : ' + avgCpuTime + ' ms and ' + avgHeapSize + ' bytes');
  }

  @AuraEnabled
  public static void objectPerformance() {
    List<Integer> cpuTimes = new List<Integer>();
    List<Integer> heapSizes = new List<Integer>();
    while (Limits.getCpuTime() / Limits.getLimitCpuTime() < 0.95) {
      Integer startCpuTime = Limits.getCpuTime();
      Integer startHeapSize = Limits.getHeapSize();

      // Do something
      for (Integer i = 0; i < ITERATION; ++i) {
        MyObject myObject = new MyObject();
        myObject.doSomethingWithObject();
      }

      Integer cpuTime = Limits.getCpuTime() - startCpuTime;
      Integer heapSize = Limits.getHeapSize() - startHeapSize;
      //System.debug(LoggingLevel.WARN, 'PERF: Object method with ' + ITERATION + ' iterations took : ' + cpuTime + ' ms and ' + HeapSize + ' bytes');
      cpuTimes.add(cpuTime);
      heapSizes.add(heapSize);
    }

    Double avgCpuTime = getAverage(cpuTimes);
    Double avgHeapSize = getAverage(heapSizes);
    System.debug(LoggingLevel.WARN, 'PERF: Object method with ' + ITERATION + ' average iterations took : ' + avgCpuTime + ' ms and ' + avgHeapSize + ' bytes');
  }

  private class MyObject {
    public void doSomethingWithObject() {
    }
  }

  public static Double getAverage(final List<Integer> ints) {
    Double avg = 0;
    if (ints?.size() > 0) {
      Integer total = 0;

      for (Integer i : ints) {
        total += i;
      }

      avg = Double.valueOf(total) / ints.size();
    }
    return avg;
  }
}
