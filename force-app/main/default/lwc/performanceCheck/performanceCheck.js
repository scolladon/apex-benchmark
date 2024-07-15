import { LightningElement, wire } from "lwc";

import getBenchmarkRegistry from "@salesforce/apex/PerformanceChecker.getBenchmarkRegistry";
import runBenchmark from "@salesforce/apex/PerformanceChecker.runBenchmark";

const columns = [
  { label: "Type", fieldName: "jobType" },
  { label: "Description", fieldName: "description" },
  { label: "Metric", fieldName: "metric" },
  { label: "Sampling Size", fieldName: "samplingSize" },
  { label: "Min", fieldName: "min", type: "number" },
  { label: "Max", fieldName: "max", type: "number" },
  { label: "Mean", fieldName: "mean", type: "number" },
  { label: "Median", fieldName: "median", type: "number" },
  { label: "Deviation", fieldName: "deviation", type: "number" },
  { label: "Variance", fieldName: "variance", type: "number" }
];

export default class PerformanceCheck extends LightningElement {
  jobRegistry = [];
  iteration;

  data = [];
  columns = columns;

  disableButton = false;
  get isButtonDisabled() {
    return !this.iteration || this.disableButton;
  }

  @wire(getBenchmarkRegistry)
  wiredJobRegistry({ error, data }) {
    if (data) {
      this.error = undefined;
      this.jobRegistry = data;
    } else if (error) {
      this.jobRegistry = undefined;
      this.error = error;
    }
  }

  async handleClick(e) {
    this.disableButton = true;
    this.error = undefined;

    const definition = e.currentTarget.dataset.id;
    const samplingSize = this.iteration;
    try {
      const executionResult = await runBenchmark({ jobConf: { jobType: { definition }, samplingSize } });
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
    this.data = this.data.concat(
      executionResult.stats.map((stat) => ({
        id: `${executionResult.jobConf.jobType.definition}-${Date.now()}`,
        jobType: executionResult.jobConf.jobType.definition,
        samplingSize: executionResult.jobConf.samplingSize,
        ...stat
      }))
    );
  }
}
