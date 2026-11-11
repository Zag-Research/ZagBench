// ZagBench – BeMatrix (JavaScript port of BeMatrix.class.st + MatrixInversion-fixed).
//
// 1-based row/col accessors, Gauss-Jordan (no partial pivoting), identity check.
// All copying / filling is hand-rolled (no map / slice / fill / Array.from / Math).
'use strict';

function zeroSquare(n) {
  const m = new Array(n);
  for (let i = 0; i < n; i++) {
    const row = new Array(n);
    for (let j = 0; j < n; j++) row[j] = 0.0;
    m[i] = row;
  }
  return m;
}

class BeMatrix {
  // Create an n×n zero matrix.
  constructor(n) {
    this._n    = n;
    this._data = zeroSquare(n);
  }

  // Create a BeMatrix holding a deep copy of the given 2-D array.
  static withData(data) {
    const n = data.length;
    const m = new BeMatrix(n);
    for (let i = 0; i < n; i++)
      for (let j = 0; j < n; j++) m._data[i][j] = data[i][j];
    return m;
  }

  get n() { return this._n; }

  // 1-based accessors
  at(row, col)             { return this._data[row - 1][col - 1]; }
  atPut(row, col, value)   { this._data[row - 1][col - 1] = value; }

  // Gauss-Jordan inversion (no partial pivoting, matches Pharo original).
  invert() {
    const n   = this._n;
    const w   = 2 * n;
    const aug = new Array(n);
    for (let i = 0; i < n; i++) {
      const row = new Array(w);
      for (let k = 0; k < w; k++) row[k] = 0.0;
      for (let j = 0; j < n; j++) row[j] = this._data[i][j];
      row[n + i] = 1.0;
      aug[i] = row;
    }

    // Normalise the pivot row, then eliminate the column from every other row
    // (same operation order as the Java and Python ports).
    for (let i = 0; i < n; i++) {
      const pivot = aug[i][i];
      for (let k = 0; k < w; k++) aug[i][k] /= pivot;
      for (let r = 0; r < n; r++) {
        if (r !== i) {
          const factor = aug[r][i];
          for (let k = 0; k < w; k++) aug[r][k] -= factor * aug[i][k];
        }
      }
    }

    // Extract right half (written straight into the result, like Java)
    const result = new BeMatrix(n);
    for (let i = 0; i < n; i++)
      for (let j = 0; j < n; j++) result._data[i][j] = aug[i][j + n];
    return result;
  }

  // O(n^3) matrix multiply
  multiply(other) {
    const n      = this._n;
    const od     = other._data;   // direct element access, like Java/Python
    const result = new BeMatrix(n);
    for (let i = 0; i < n; i++) {
      for (let j = 0; j < n; j++) {
        let s = 0.0;
        for (let k = 0; k < n; k++) s += this._data[i][k] * od[k][j];
        result._data[i][j] = s;
      }
    }
    return result;
  }

  // Identity check with epsilon = 1e-9
  isIdentityMatrix() {
    const eps = 1e-9;
    for (let i = 0; i < this._n; i++) {
      for (let j = 0; j < this._n; j++) {
        const expected = i === j ? 1.0 : 0.0;
        let diff = this._data[i][j] - expected;
        if (diff < 0.0) diff = -diff;
        if (diff > eps) return false;
      }
    }
    return true;
  }
}

module.exports = { BeMatrix };
