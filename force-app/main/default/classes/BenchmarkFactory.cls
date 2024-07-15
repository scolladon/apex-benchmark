public class BenchmarkFactory {
  public BenchmarkJob getSubject(BenchmarkModel.JobType jobType) {
    return (BenchmarkJob) Type.forName(jobType.definition).newInstance();
  }

  public List<BenchmarkModel.JobType> listAvailableJobs() {
    final List<BenchmarkModel.JobType> jobTypes = new List<BenchmarkModel.JobType>();

    for (ApexTypeImplementor implem : [SELECT ClassName FROM ApexTypeImplementor WHERE InterfaceName = :BenchmarkJob.class.getName() AND IsConcrete = TRUE]) {
      final BenchmarkModel.JobType jobType = new BenchmarkModel.JobType();
      jobType.definition = implem.ClassName;
      jobTypes.add(jobType);
    }
    return jobTypes;
  }
}
