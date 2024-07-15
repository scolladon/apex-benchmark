public class JobConf {
  @AuraEnabled
  public JobType jobType { get; set; }

  @AuraEnabled
  public Integer samplingSize { get; set; }

  @AuraEnabled
  public List<MetricType> metrics { get; set; }
}
