public class BenchmarkModel {
  public class JobConf {
    @AuraEnabled
    public JobType jobType { get; set; }

    @AuraEnabled
    public Integer samplingSize { get; set; }
  }
  public class JobType {
    @AuraEnabled
    public String definition { get; set; }
  }
}
