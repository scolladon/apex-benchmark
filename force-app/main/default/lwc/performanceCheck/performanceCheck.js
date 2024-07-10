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
    this.addStats(executionResult, "Static");
    this.disableButton = false;
  }

  async objectClick() {
    this.disableButton = true;
    const executionResult = await objectPerformance({ iteration: this.iteration });
    this.addStats(executionResult, "Object");
    this.disableButton = false;
  }

  handleIterationChange(e) {
    this.iteration = e.detail.value;
  }

  addStats(executionResult, jpbType) {
    const type = `${jpbType}(${this.iteration} sampling size)`;
    this.addStat(
      type,
      "ms",
      executionResult.stats.find((stat) => stat.description === "cpu time")
    );
    this.addStat(
      type,
      "bytes",
      executionResult.stats.find((stat) => stat.description === "heap size")
    );
    this.data = [...this.data];
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
