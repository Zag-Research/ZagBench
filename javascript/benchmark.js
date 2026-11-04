// ZagBench – Benchmark base class (JavaScript port).
'use strict';

class Benchmark {
  static get mainIterations()  { return 10; }
  static get innerIterations() { return 250000; }

  innerBenchmarkLoop(innerIterations) {
    throw new Error('Subclass must implement innerBenchmarkLoop');
  }
}

module.exports = { Benchmark };
