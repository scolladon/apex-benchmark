import { LightningElement, track } from "lwc";

import staticPerformance from "@salesforce/apex/PerformanceChecker.staticPerformance";
import objectPerformance from "@salesforce/apex/PerformanceChecker.objectPerformance";

const columns = [
  { label: "Type", fieldName: "type" },
  { label: "Metric", fieldName: "metric" },
  { label: "Min", fieldName: "min", type: "number" },
  { label: "Max", fieldName: "max", type: "number" },
  { label: "Mean", fieldName: "mean", type: "number" },
  { label: "Median", fieldName: "median", type: "number" }
];

export default class PerformanceCheck extends LightningElement {
  disableButton = false;

  iteration;

  @track
  data = [];

  columns = columns;

  get isButtonDisabled() {
    return !this.iteration || this.disableButton;
  }

  async staticClick() {
    this.disableButton = true;
    const executionResult = await staticPerformance({ iteration: this.iteration });
    const type = `Static(${this.iteration} iterations)`;
    this.addStat(type, "ms", executionResult.cpuMetrics);
    this.addStat(type, "bytes", executionResult.heapSizeMetrics);
    this.data = [...this.data];
    this.disableButton = false;
  }

  async objectClick() {
    this.disableButton = true;
    const executionResult = await objectPerformance({ iteration: this.iteration });
    const type = `Object(${this.iteration} iterations)`;
    this.addStat(type, "ms", executionResult.cpuMetrics);
    this.addStat(type, "bytes", executionResult.heapSizeMetrics);
    this.data = [...this.data];
    this.disableButton = false;
  }

  handleIterationChange(e) {
    this.iteration = e.detail.value;
  }

  addStat(type, metric, stats) {
    this.data.push({
      id: `${type}-${metric}-${this.iteration}-${Date.now()}`,
      ...stats,
      type,
      metric
    });
  }
}
