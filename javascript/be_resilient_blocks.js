// ZagBench – BeResilientBlocks (JavaScript port of BeResilientBlocks.class.st).
//
// Stresses object allocation by building linked lists of sizes 1..iterations-1.
// Verify: evaluate(2500) == 3123750  (= Σ i for i=1..2499)
'use strict';

const { Benchmark }       = require('./benchmark');
const { BeResilientList } = require('./be_resilient_list');

class BeResilientBlocks extends Benchmark {
  static get mainIterations()  { return 15; }
  static get innerIterations() { return 2500; }

  innerBenchmarkLoop(innerIterations) {
    return this._verify(this._evaluate(innerIterations), innerIterations);
  }

  _evaluate(iterations) {
    let total = 0;
    for (let size = 1; size < iterations; size++) {
      total += BeResilientList.build(size).size();
    }
    return total;
  }

  _verify(result, iterations) {
    // Σ size for size = 1..iterations-1 (3123750 for the default 2500)
    const expected = iterations * (iterations - 1) / 2;
    if (result === expected) return true;
    process.stdout.write(`ResilientBlocks mismatch: got ${result} expected ${expected}\n`);
    return false;
  }
}

module.exports = { BeResilientBlocks };
