// ZagBench – BeMemoizedFibonacci (JavaScript port of BeMemoizedFibonacci.class.st).
//
// JavaScript's native BigInt handles arbitrary-precision integers natively.
// Cache built iteratively to avoid stack overflow for large n.
'use strict';

const { Benchmark } = require('./benchmark');
const { BeIntMap }  = require('./be_int_map');

class BeMemoizedFibonacci extends Benchmark {
  static get mainIterations()  { return 10; }
  static get innerIterations() { return 250000; }

  constructor() {
    super();
    this._cache = new BeIntMap();   // hand-rolled, same algorithm in all ports
  }

  fibMemo(n) {
    if (n <= 1) return BigInt(n);
    const hit = this._cache.get(n);
    if (hit !== null) return hit;
    // Build bottom-up iteratively from 2..n
    let a = 0n, b = 1n;
    for (let i = 2; i <= n; i++) {
      const next = a + b;
      a = b;
      b = next;
      this._cache.put(i, b);
    }
    return this._cache.get(n);
  }

  innerBenchmarkLoop(innerIterations) {
    let result = null;
    for (let i = 0; i < innerIterations; i++) result = this.fibMemo(200000);
    // fib(200000) mod 1e9+7, identical in every port
    if (result !== null && result % 1000000007n !== 216653165n) {
      process.stdout.write(`Fibonacci mismatch: fib(200000) mod 1e9+7 = ${result % 1000000007n}\n`);
      return false;
    }
    return true;
  }
}

module.exports = { BeMemoizedFibonacci };
