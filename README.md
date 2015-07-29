# Apex-Benchmarker

<a href="https://githubsfdeploy.herokuapp.com?owner=ForceComDeveloper&repo=Apex-Benchmarker">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

The purpose of this project is to provide a simple Benchmarker.

The Benchmarker is divided in 3 Part :
* The Benchmarker Core (contains the main algorithm) => Benchmarker class (Base class, Method Chaining)
* The Profiling Core (the canvas for building profiler) => AProfiler (Abstract class, Decorator, Template Method)
* The Benchmarking strategy (the canvas to define what to benchmark) => AbstractBenchmarkStrategy (Abstract class)

The documentation is in the doc folder
