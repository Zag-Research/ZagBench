"""
ZagBench – BeResilientBlocks (Python port of BeResilientBlocks.class.st).

Stresses closure/block creation by building linked lists of increasing
length and summing their sizes.

Verify: evaluate(2500) == 3123750   (= Σ i for i=1..2499 = 2499·2500/2)
"""
from benchmark import Benchmark
from be_resilient_list import BeResilientList


class BeResilientBlocks(Benchmark):
    """Sum sizes of linked lists from 1 to inner_iterations-1."""

    MAIN_ITERATIONS  = 15
    INNER_ITERATIONS = 2500

    def inner_benchmark_loop(self, inner_iterations):
        return self._verify(self._evaluate(inner_iterations), inner_iterations)

    # ------------------------------------------------------------------
    # Core algorithm
    # ------------------------------------------------------------------

    def _evaluate(self, iterations):
        """Return Σ BeResilientList.build(size).size() for size in [1, iterations)."""
        total = 0
        size  = 1
        while size < iterations:
            lst    = BeResilientList.build(size)
            total += lst.size()
            size  += 1
        return total

    # ------------------------------------------------------------------
    # Verification
    # ------------------------------------------------------------------

    def _verify(self, result, iterations):
        # Σ size for size = 1..iterations-1 (3123750 for the default 2500)
        expected = iterations * (iterations - 1) // 2
        if result == expected:
            return True
        print("ResilientBlocks mismatch: got {} expected {}".format(result, expected))
        return False
