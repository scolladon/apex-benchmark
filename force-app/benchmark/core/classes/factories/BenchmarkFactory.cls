public class BenchmarkFactory {
  public BenchmarkJob getSubject(JobType jobType) {
    return (BenchmarkJob) Type.forName(jobType.definition).newInstance();
  }

  public Profiler getAggregator(MetricType metricType) {
    return (Profiler) Type.forName(metricType.definition).newInstance();
  }

  public List<JobType> listAvailableJobs() {
    final List<JobType> jobTypes = new List<JobType>();

    for (ApexTypeImplementor implem : [SELECT ClassName FROM ApexTypeImplementor WHERE InterfaceName = :BenchmarkJob.class.getName() AND IsConcrete = TRUE]) {
      final JobType jobType = new JobType();
      jobType.definition = implem.ClassName;
      jobTypes.add(jobType);
    }
    return jobTypes;
  }

  public List<MetricType> listAvailableMetrics() {
    final List<MetricType> metricTypes = new List<MetricType>();

    for (ApexTypeImplementor implem : [SELECT ClassName FROM ApexTypeImplementor WHERE InterfaceName = :Profiler.class.getName() AND IsConcrete = TRUE]) {
      final MetricType metricType = new MetricType();
      metricType.definition = implem.ClassName;
      metricTypes.add(metricType);
    }
    return metricTypes;
  }
}