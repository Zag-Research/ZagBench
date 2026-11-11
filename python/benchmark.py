"""
ZagBench – base Benchmark class (Python port of Benchmark.class.st).
No standard-library imports: all computation in subclasses is hand-rolled.
"""


class Benchmark:
    """Abstract base for every ZagBench benchmark.

    Sub-classes must override ``inner_benchmark_loop`` (and optionally
    declare ``MAIN_ITERATIONS`` / ``INNER_ITERATIONS`` class variables to
    set per-benchmark defaults used by the Run harness).
    """

    # Override these in sub-classes to set benchmark-specific defaults.
    MAIN_ITERATIONS = 10
    INNER_ITERATIONS = 250000

    def inner_benchmark_loop(self, inner_iterations):
        """Run the benchmark for *inner_iterations* and return True on success."""
        raise NotImplementedError(
            "Sub-classes must implement inner_benchmark_loop(inner_iterations)"
        )
