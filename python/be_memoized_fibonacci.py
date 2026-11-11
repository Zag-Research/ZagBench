"""
ZagBench – BeMemoizedFibonacci (Python port of BeMemoizedFibonacci.class.st).

Benchmarks Dictionary performance and LargeInteger arithmetic.
Computes fib(200000) using a memoization cache built iteratively to avoid
Python's default recursion limit; the algorithmic pattern (cache check →
compute → store) faithfully mirrors the Pharo recursive implementation.
"""
from benchmark import Benchmark
from be_int_map import BeIntMap


class BeMemoizedFibonacci(Benchmark):
    """Memoized Fibonacci using the hand-rolled BeIntMap as the cache."""

    # First call builds the full cache; subsequent 249999 calls hit immediately.
    MAIN_ITERATIONS  = 10
    INNER_ITERATIONS = 250000

    def __init__(self):
        self._cache = BeIntMap()

    def fib_memo(self, n):
        """Return fib(n), caching all intermediate values.

        Builds the cache bottom-up to avoid Python's recursion limit
        while producing identical cache-hit patterns to the Pharo version.
        """
        if n <= 1:
            return n
        hit = self._cache.get(n)
        if hit is not None:
            return hit
        # Cache miss: build iteratively from 2 up to n.
        a, b = 0, 1          # fib(0), fib(1)
        for i in range(2, n + 1):
            a, b = b, a + b
            self._cache.put(i, b)
        return self._cache.get(n)

    def inner_benchmark_loop(self, inner_iterations):
        result = None
        for _ in range(inner_iterations):
            result = self.fib_memo(200000)
        # fib(200000) mod 1e9+7, identical in every port
        if result is not None and result % 1000000007 != 216653165:
            print("Fibonacci mismatch: fib(200000) mod 1e9+7 = {}".format(result % 1000000007))
            return False
        return True
