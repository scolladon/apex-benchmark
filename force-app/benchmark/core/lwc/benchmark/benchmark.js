import { LightningElement, track, wire } from "lwc";

import getBenchmarkRegistry from "@salesforce/apex/Benchmarker.getBenchmarkRegistry";
import getMetricRegistry from "@salesforce/apex/Benchmarker.getMetricRegistry";
import runBenchmark from "@salesforce/apex/Benchmarker.runBenchmark";

const columns = [
  { label: "Job", fieldName: "jobType" },
  { label: "Mesure", fieldName: "description" },
  { label: "Min", fieldName: "min" },
  { label: "Max", fieldName: "max" },
  { label: "Mean", fieldName: "mean" },
  { label: "Median", fieldName: "median" },
  { label: "Deviation", fieldName: "deviation" },
  { label: "Variance", fieldName: "variance" },
  { label: "ops/s", fieldName: "opsecond" },
  { label: "Iteration Count", fieldName: "iterationCount" },
  { label: "Sampling Size", fieldName: "samplingSize" }
];

const splitSnakeCase = (str) => str?.split(/([A-Z][a-z]+|[A-Z]+?(?=[A-Z][a-z]+|$))/g).join(" ");

export default class PerformanceCheck extends LightningElement {
  jobRegistry = [];
  metricRegistry = [];
  iteration;

  stats = [];
  columns = columns;

  @track
  selectedMetrics = [];

  disableButton = false;
  get isButtonDisabled() {
    return !this.iteration || this.disableButton || this.selectedMetrics.length === 0;
  }

  @wire(getBenchmarkRegistry)
  wiredJobRegistry({ error, data }) {
    if (data) {
      this.error = undefined;
      this.jobRegistry = data.map((job) => ({ ...job, label: splitSnakeCase(job.definition) }));
    } else if (error) {
      this.jobRegistry = undefined;
      this.error = error;
    }
  }

  @wire(getMetricRegistry)
  wiredMetricRegistry({ error, data }) {
    if (data) {
      this.error = undefined;
      this.metricRegistry = data.map((metric) => ({ ...metric, label: splitSnakeCase(metric.definition) }));
    } else if (error) {
      this.metricRegistry = undefined;
      this.error = error;
    }
  }

  handleMetricChoice(e) {
    const definition = e.currentTarget.dataset.id;
    const checked = e.detail.checked;

    if (checked) {
      this.selectedMetrics.push({ definition });
    } else {
      this.selectedMetrics = this.selectedMetrics.filter((metric) => metric.definition !== definition);
    }
  }

  async handleJobClick(e) {
    this.disableButton = true;
    this.error = undefined;

    const definition = e.currentTarget.dataset.id;
    const samplingSize = this.iteration;
    const metrics = this.selectedMetrics;
    try {
      const executionResult = await runBenchmark({ jobConf: { jobType: { definition }, samplingSize, metrics } });
      this.addStats(executionResult);
    } catch (error) {
      this.error = error;
    } finally {
      this.disableButton = false;
    }
  }

  handleIterationChange(e) {
    this.iteration = e.detail.value;
  }

  addStats(executionResult) {
    this.stats = this.stats.concat(
      executionResult.stats.map((stat) => ({
        id: `${executionResult.jobConf.jobType.definition}-${Date.now()}`,
        jobType: splitSnakeCase(executionResult.jobConf.jobType.definition),
        samplingSize: executionResult.jobConf.samplingSize,
        iterationCount: executionResult.iterationCount,
        opsecond: executionResult.iterationCount / 10,
        ...stat,
        max: `${stat.max} ${stat.metric}`,
        min: `${stat.min} ${stat.metric}`,
        median: `${stat.median} ${stat.metric}`,
        mean: `${Number(stat.mean)?.toPrecision(6)} ${stat.metric}`,
        deviation: `${Number(stat.deviation)?.toPrecision(6)} ${stat.metric}`,
        variance: `${Number(stat.variance)?.toPrecision(6)} ${stat.metric}`
      }))
    );
  }
}
