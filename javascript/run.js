// ZagBench – Run / harness class (JavaScript port).
//
// Hand-rolled helpers: Newton sqrt, insertion sort, quartiles.
// Timing uses process.hrtime.bigint() (Node built-in, no require needed).
'use strict';

// ---------------------------------------------------------------------------
// Hand-rolled statistics helpers
// ---------------------------------------------------------------------------

function _mySqrt(x) {
  if (x <= 0.0) return 0.0;
  let g = x / 2.0;
  for (let i = 0; i < 200; i++) {
    const ng   = (g + x / g) * 0.5;
    let   diff = ng - g;
    if (diff < 0.0) diff = -diff;
    if (diff < 1.0e-15 * g) return ng;
    g = ng;
  }
  return g;
}

function _insertionSort(arr) {
  const n = arr.length;
  for (let i = 1; i < n; i++) {
    const key = arr[i];
    let j = i - 1;
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    arr[j + 1] = key;
  }
}

function _medianOf(sorted, from, to) {
  const len = to - from;
  if (len <= 0) return 0;
  const mid = from + Math.trunc(len / 2);
  if (len % 2 === 1) return sorted[mid];
  return Math.trunc((sorted[mid - 1] + sorted[mid]) / 2);
}

function _quartiles(times) {
  if (times.length === 0) return [0, 0, 0];
  const n = times.length;
  const s = new Array(n);
  for (let i = 0; i < n; i++) s[i] = times[i];
  _insertionSort(s);
  const mid = Math.trunc(n / 2);
  const med = _medianOf(s, 0, n);
  if (n < 2) return [med, med, med]; // halves are empty
  const q1 = _medianOf(s, 0, mid);
  const q3  = (n % 2 === 1) ? _medianOf(s, mid + 1, n) : _medianOf(s, mid, n);
  return [q1, med, q3];
}

// ---------------------------------------------------------------------------
// Benchmark name → [file, class] registry
// ---------------------------------------------------------------------------

const REGISTRY = {
  'memoizedfibonacci':   ['./be_memoized_fibonacci',  'BeMemoizedFibonacci'],
  'bememoizedfibonacci': ['./be_memoized_fibonacci',  'BeMemoizedFibonacci'],
  'fannkuch':            ['./be_fannkuch',              'BeFannkuch'],
  'befannkuch':          ['./be_fannkuch',              'BeFannkuch'],
  'matrixinversion':     ['./be_matrix_inversion',      'BeMatrixInversion'],
  'bematrixinversion':   ['./be_matrix_inversion',      'BeMatrixInversion'],
  'resilientblocks':     ['./be_resilient_blocks',      'BeResilientBlocks'],
  'beresilientblocks':   ['./be_resilient_blocks',      'BeResilientBlocks'],
  'stressgc':            ['./be_stress_gc',              'BeStressGC'],
  'bestressgc':          ['./be_stress_gc',              'BeStressGC'],
  'dataframe':           ['./be_data_frame',             'BeDataFrame'],
  'bedataframe':         ['./be_data_frame',             'BeDataFrame'],
};

// ---------------------------------------------------------------------------
// Run class
// ---------------------------------------------------------------------------

class Run {
  constructor(name) {
    this._name             = name;
    this._numIterations    = null;
    this._innerIterations  = null;
    this._total            = 0;
    this._totalSq          = 0;
    this._times            = [];
  }

  setNumIterations(n)   { this._numIterations   = n; }
  setInnerIterations(n) { this._innerIterations = n; }

  runBenchmark() {
    process.stdout.write(`Starting ${this._name} benchmark ...\n`);

    const key   = this._name.toLowerCase();
    const entry = REGISTRY[key];
    if (!entry) throw new Error(`Unknown benchmark: ${this._name}`);

    const [filePath, className] = entry;
    const mod        = require(filePath);
    const BenchClass = mod[className];

    const ni = this._numIterations   !== null ? this._numIterations   : BenchClass.mainIterations;
    const ii = this._innerIterations !== null ? this._innerIterations : BenchClass.innerIterations;
    this._numIterations = ni;

    for (let i = 0; i < ni; i++) {
      const bench = new BenchClass();
      this._measure(bench, ii);
    }
  }

  printTotal() {
    this._report();
  }

  // -------------------------------------------------------------------------

  _measure(bench, ii) {
    const startNs = process.hrtime.bigint();
    const ok      = bench.innerBenchmarkLoop(ii);
    const endNs   = process.hrtime.bigint();

    if (!ok) throw new Error('Benchmark failed with incorrect result');

    const runTimeUs = Number((endNs - startNs) / 1000n);
    this._times.push(runTimeUs);
    this._totalSq += runTimeUs * runTimeUs;
    this._total   += runTimeUs;
  }

  _mean() {
    return Math.trunc(this._total / this._numIterations);
  }

  _stdDev() {
    const n    = this._numIterations;
    const mean = this._total / n;
    const vari = this._totalSq / n - mean * mean;
    return _mySqrt(vari);
  }

  _report() {
    const n      = this._numIterations;
    const mean   = this._mean();
    const stdDev = this._stdDev();
    const pct    = mean > 0 ? (stdDev / mean * 100.0) : 0.0;
    const qs     = _quartiles(this._times);
    let   mn     = this._times[0];
    let   mx     = this._times[0];
    for (let i = 1; i < this._times.length; i++) {
      if (this._times[i] < mn) mn = this._times[i];
      if (this._times[i] > mx) mx = this._times[i];
    }

    process.stdout.write(
      `${this._name}: n=${n} mean: ${mean}us stdDev: ${Math.trunc(stdDev)}us ` +
      `(${pct.toFixed(1)}%) min: ${mn}us 1stQ: ${qs[0]}us median: ${qs[1]}us ` +
      `3rdQ: ${qs[2]}us max: ${mx}us\n`
    );
  }
}

module.exports = { Run };
