# ZagBench – Benchmark base class (Ruby port of Benchmark.class.st).
# No require statements for computational libraries in benchmark logic.

class Benchmark
  # Override in subclasses for per-benchmark defaults
  def self.main_iterations  = 10
  def self.inner_iterations = 250_000

  # Run the benchmark inner_iterations times; return true on success.
  def inner_benchmark_loop(inner_iterations)
    raise NotImplementedError, "#{self.class}#inner_benchmark_loop not implemented"
  end
end
