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
