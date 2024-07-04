import { LightningElement } from "lwc";

import staticPerformance from "@salesforce/apex/PerformanceChecker.staticPerformance";
import objectPerformance from "@salesforce/apex/PerformanceChecker.objectPerformance";

export default class PerformanceCheck extends LightningElement {
  async staticClick() {
    await staticPerformance();
  }

  async objectClick() {
    await objectPerformance();
  }
}
