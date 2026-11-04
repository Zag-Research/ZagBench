// ZagBench – BeMatrixInversion (JavaScript port of BeMatrixInversion.class.st).
'use strict';

const { Benchmark } = require('./benchmark');
const { BeRandom }  = require('./be_random');
const { BeMatrix }  = require('./be_matrix');

const SIZE = 10;

class BeMatrixInversion extends Benchmark {
  static get mainIterations()  { return 10; }
  static get innerIterations() { return 250; }

  constructor() {
    super();
    const rng    = new BeRandom();
    this._source = BeMatrix.withData(rng.makeInvertable(SIZE));
  }

  innerBenchmarkLoop(innerIterations) {
    let result = true;
    for (let i = 0; i < innerIterations; i++) result = this._multiplyInverse() && result;
    return result;
  }

  _multiplyInverse() {
    const inv    = this._source.invert();
    const result = inv.multiply(this._source);
    return result.isIdentityMatrix();
  }
}

module.exports = { BeMatrixInversion };
