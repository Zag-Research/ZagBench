"""
ZagBench – BeMatrixInversion (Python port of BeMatrixInversion.class.st).

Benchmarks matrix inversion (Gauss-Jordan) and multiplication.
Verifies result by checking A^-1 * A ≈ I (epsilon = 1e-9).
"""
from benchmark import Benchmark
from be_random import BeRandom
from be_matrix import BeMatrix


class BeMatrixInversion(Benchmark):
    """Repeatedly invert a 10×10 matrix and verify the result."""

    MAIN_ITERATIONS  = 10
    INNER_ITERATIONS = 250

    def __init__(self):
        rng               = BeRandom()
        self._size        = 10
        self._source      = BeMatrix.with_data(rng.make_invertable(self._size))

    def inner_benchmark_loop(self, inner_iterations):
        result = True
        for _ in range(inner_iterations):
            # Always run every iteration (no short-circuit), like Java's '&'.
            result = self._multiply_inverse() and result
        return result

    def _multiply_inverse(self):
        """Invert sourceMatrix then multiply; check A^-1 * A ≈ I."""
        inv    = self._source.invert()
        result = inv.multiply(self._source)
        return result.is_identity_matrix()
