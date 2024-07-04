public with sharing class PerformanceChecker {
  private static Integer ITERATION = 10000;
  public static void doSomethingStatic() {
  }

  @AuraEnabled
  public static void staticPerformance() {
    while (Limits.getCpuTime() / Limits.getLimitCpuTime() < 0.95) {
      Integer startCpuTime = Limits.getCpuTime();
      Integer startHeapSize = Limits.getHeapSize();

      // Do something
      for (Integer i = 0; i < ITERATION; ++i) {
        doSomethingStatic();
      }

      Integer endCpuTime = Limits.getCpuTime();
      Integer endHeapSize = Limits.getHeapSize();
      System.debug(
        LoggingLevel.WARN,
        'PERF: Static method with ' +
          ITERATION +
          ' iterations took : ' +
          (endCpuTime - startCpuTime) +
          ' ms and ' +
          (endHeapSize - startHeapSize) +
          ' bytes'
      );
    }
  }

  @AuraEnabled
  public static void objectPerformance() {
    while (Limits.getCpuTime() / Limits.getLimitCpuTime() < 0.95) {
      Integer startCpuTime = Limits.getCpuTime();
      Integer startHeapSize = Limits.getHeapSize();

      // Do something
      for (Integer i = 0; i < ITERATION; ++i) {
        MyObject myObject = new MyObject();
        myObject.doSomethingWithObject();
      }

      Integer endCpuTime = Limits.getCpuTime();
      Integer endHeapSize = Limits.getHeapSize();
      System.debug(
        LoggingLevel.WARN,
        'PERF: Object method with ' +
          ITERATION +
          ' iterations took : ' +
          (endCpuTime - startCpuTime) +
          ' ms and ' +
          (endHeapSize - startHeapSize) +
          ' bytes'
      );
    }
  }

  private class MyObject {
    public void doSomethingWithObject() {
    }
  }
}
