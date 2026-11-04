"""
ZagBench – Run / harness class (Python port of Benchmark.class.st timing logic).

Only sys and time are imported here (harness infrastructure).
All statistics helpers are hand-rolled (no math / statistics module).
"""
import sys
import time


# ---------------------------------------------------------------------------
# Hand-rolled statistics helpers (no math / statistics import)
# ---------------------------------------------------------------------------

def _my_sqrt(x):
    """Newton's-method square root – no math.sqrt."""
    if x <= 0.0:
        return 0.0
    guess = x / 2.0
    for _ in range(200):
        next_g = (guess + x / guess) * 0.5
        diff = next_g - guess
        if diff < 0.0:
            diff = -diff
        if diff < 1.0e-15 * guess:
            return next_g
        guess = next_g
    return guess


def _insertion_sort(lst):
    """In-place insertion sort on a plain Python list."""
    n = len(lst)
    for i in range(1, n):
        key = lst[i]
        j = i - 1
        while j >= 0 and lst[j] > key:
            lst[j + 1] = lst[j]
            j -= 1
        lst[j + 1] = key


def _median_of(arr, start, stop):
    """Median of sorted arr[start:stop] (integer truncation for even length)."""
    n = stop - start
    if n <= 0:
        return 0
    mid = start + n // 2
    if n % 2 == 1:
        return arr[mid]
    return (arr[mid - 1] + arr[mid]) // 2


def _quartiles(times):
    """Return [Q1, median, Q3] of *times* (a list of integer µs values)."""
    n = len(times)
    if n == 0:
        return [0, 0, 0]
    s = [0] * n
    for i in range(n):
        s[i] = times[i]
    _insertion_sort(s)
    mid    = n // 2
    median = _median_of(s, 0, n)
    if n < 2:
        return [median, median, median]  # halves are empty
    q1    = _median_of(s, 0, mid)
    q3     = _median_of(s, mid + 1, n) if n % 2 == 1 else _median_of(s, mid, n)
    return [q1, median, q3]


# ---------------------------------------------------------------------------
# Benchmark name → (module_name, class_name) registry
# ---------------------------------------------------------------------------

_REGISTRY = {
    "memoizedfibonacci":   ("be_memoized_fibonacci",  "BeMemoizedFibonacci"),
    "bememoizedfibonacci": ("be_memoized_fibonacci",  "BeMemoizedFibonacci"),
    "fannkuch":            ("be_fannkuch",             "BeFannkuch"),
    "befannkuch":          ("be_fannkuch",             "BeFannkuch"),
    "matrixinversion":     ("be_matrix_inversion",     "BeMatrixInversion"),
    "bematrixinversion":   ("be_matrix_inversion",     "BeMatrixInversion"),
    "resilientblocks":     ("be_resilient_blocks",     "BeResilientBlocks"),
    "beresilientblocks":   ("be_resilient_blocks",     "BeResilientBlocks"),
    "stressgc":            ("be_stress_gc",            "BeStressGC"),
    "bestressgc":          ("be_stress_gc",            "BeStressGC"),
    "dataframe":           ("be_data_frame",           "BeDataFrame"),
    "bedataframe":         ("be_data_frame",           "BeDataFrame"),
}


class Run:
    """Times a benchmark and reports statistics matching Pharo's reportBenchmark."""

    def __init__(self, name):
        self._name = name
        self._num_iterations = None   # None → use bench class default
        self._inner_iterations = None # None → use bench class default
        self._total = 0
        self._total_sq = 0
        self._times = []

    # ------------------------------------------------------------------
    # Public API used by harness.py
    # ------------------------------------------------------------------

    def set_num_iterations(self, n):
        self._num_iterations = n

    def set_inner_iterations(self, n):
        self._inner_iterations = n

    def run_benchmark(self):
        print("Starting {} benchmark ...".format(self._name), flush=True)
        bench_class = self._load_benchmark_class()

        num_iters   = self._num_iterations   if self._num_iterations   is not None \
                      else bench_class.MAIN_ITERATIONS
        inner_iters = self._inner_iterations if self._inner_iterations is not None \
                      else bench_class.INNER_ITERATIONS

        for _ in range(num_iters):
            bench = bench_class()
            self._measure(bench, inner_iters)

        self._num_iterations = num_iters  # remember for print_total

    def print_total(self):
        self._report()

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    def _load_benchmark_class(self):
        key = self._name.lower()
        if key not in _REGISTRY:
            raise RuntimeError("Unknown benchmark: {}".format(self._name))
        module_name, class_name = _REGISTRY[key]
        # Use built-in __import__ – no 'import importlib' needed.
        mod = __import__(module_name)
        return getattr(mod, class_name)

    def _measure(self, bench, inner_iterations):
        start_us = time.perf_counter_ns() // 1000
        ok = bench.inner_benchmark_loop(inner_iterations)
        end_us = time.perf_counter_ns() // 1000

        if not ok:
            raise RuntimeError("Benchmark failed with incorrect result")

        run_time = end_us - start_us
        self._times.append(run_time)
        self._total_sq += run_time * run_time
        self._total     += run_time

    def _mean(self):
        return self._total // self._num_iterations

    def _std_dev(self):
        n    = self._num_iterations
        mean = self._total / n
        var  = self._total_sq / n - mean * mean
        return _my_sqrt(var)

    def _report(self):
        n       = self._num_iterations
        mean    = self._mean()
        std_dev = self._std_dev()
        pct     = (std_dev / mean * 100.0) if mean > 0 else 0.0
        qs      = _quartiles(self._times)
        mn      = self._times[0]
        mx      = self._times[0]
        for i in range(1, len(self._times)):
            t = self._times[i]
            if t < mn:
                mn = t
            if t > mx:
                mx = t
        print(
            "{name}: n={n} mean: {mean}us stdDev: {sd}us ({pct:.1f}%)"
            " min: {mn}us 1stQ: {q1}us median: {q2}us 3rdQ: {q3}us max: {mx}us".format(
                name=self._name, n=n,
                mean=mean, sd=int(std_dev), pct=pct,
                mn=mn, q1=qs[0], q2=qs[1], q3=qs[2], mx=mx,
            )
        )
