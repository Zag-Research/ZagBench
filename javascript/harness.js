#!/usr/bin/env node
// ZagBench – JavaScript harness entry point.
// Usage: node harness.js <BenchmarkName> [numIterations [innerIterations]]
//
// Example:
//   node harness.js MemoizedFibonacci
//   node harness.js Fannkuch 2 10
//   node harness.js MatrixInversion 10 250
//   node harness.js DataFrame 10 500
'use strict';

const { Run } = require('./run');

function printUsage() {
  process.stdout.write('Usage: node harness.js <benchmark> [num-iterations [inner-iter]]\n');
  process.stdout.write('\n');
  process.stdout.write('  benchmark  BeMemoizedFibonacci | BeFannkuch | BeMatrixInversion |\n');
  process.stdout.write('             BeResilientBlocks   | BeStressGC | BeDataFrame\n');
}

const args = process.argv.slice(2);
if (args.length < 1) {
  printUsage();
  process.exit(1);
}

// Parse a whole number >= 1, or print usage and exit 1.
function parsePositive(s, what) {
  if (!/^\d+$/.test(s) || parseInt(s, 10) < 1) {
    process.stdout.write(`Error: ${what} must be a whole number >= 1, got '${s}'\n`);
    printUsage();
    process.exit(1);
  }
  return parseInt(s, 10);
}

const run = new Run(args[0]);
if (args.length > 1) run.setNumIterations(parsePositive(args[1], 'num-iterations'));
if (args.length > 2) run.setInnerIterations(parsePositive(args[2], 'inner-iter'));

run.runBenchmark();
run.printTotal();
