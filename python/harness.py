#!/usr/bin/env python3
"""
ZagBench – Python harness entry point.
Usage: python harness.py <BenchmarkName> [numIterations [innerIterations]]

Example:
  python harness.py MemoizedFibonacci
  python harness.py Fannkuch 2 10
  python harness.py MatrixInversion 10 250
  python harness.py DataFrame 10 500

Run from the directory containing mnist_test.csv when running BeDataFrame.
"""
import sys
from run import Run


def _print_usage():
    print("Usage: python harness.py <benchmark> [num-iterations [inner-iter]]")
    print()
    print("  benchmark      BeMemoizedFibonacci | BeFannkuch | BeMatrixInversion |")
    print("                 BeResilientBlocks   | BeStressGC | BeDataFrame")
    print("  num-iterations number of timed runs (default: benchmark default)")
    print("  inner-iter     inner loop count    (default: benchmark default)")


if len(sys.argv) < 2:
    _print_usage()
    sys.exit(1)

def _parse_positive(s, what):
    """Parse a whole number >= 1, or print usage and exit 1."""
    if not (s.isascii() and s.isdigit()) or int(s) < 1:
        print("Error: {} must be a whole number >= 1, got '{}'".format(what, s))
        _print_usage()
        sys.exit(1)
    return int(s)


run = Run(sys.argv[1])
if len(sys.argv) > 2:
    run.set_num_iterations(_parse_positive(sys.argv[2], "num-iterations"))
if len(sys.argv) > 3:
    run.set_inner_iterations(_parse_positive(sys.argv[3], "inner-iter"))

run.run_benchmark()
run.print_total()
