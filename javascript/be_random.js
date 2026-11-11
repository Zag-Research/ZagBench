// ZagBench – BeRandom LCG (JavaScript port).
// JavaScript numbers are IEEE-754 doubles; we use BigInt for the multiply
// to avoid precision loss in the LCG accumulation, then convert back.
'use strict';

const MULTIPLIER = 1103515245n;
const INCREMENT  = 12345n;
const MODULUS    = 2147483648n;   // 2^31
const SCALE      = 1.0 / 2147483648.0;

class BeRandom {
  constructor() {
    this._rand = 12345n;
  }

  next() {
    this._rand = (MULTIPLIER * this._rand + INCREMENT) % MODULUS;
    return Number(this._rand) * SCALE;
  }

  nextInteger(n) {
    return Math.trunc(this.next() * n) + 1;
  }

  randomSquare(size) {
    const m = [];
    for (let i = 0; i < size; i++) {
      const row = [];
      for (let j = 0; j < size; j++) row.push(this.next());
      m.push(row);
    }
    return m;
  }

  makeInvertable(size) {
    const matrix = this.randomSquare(size);
    for (let i = 0; i < size; i++) {
      let rowSum = 0.0;
      for (let j = 0; j < size; j++) {
        const v = matrix[i][j];
        rowSum += v >= 0.0 ? v : -v;
      }
      matrix[i][i] = rowSum;   // diagonal = sum of absolute values
    }
    return matrix;
  }
}

module.exports = { BeRandom };
