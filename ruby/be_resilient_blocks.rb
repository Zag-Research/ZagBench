# ZagBench – BeResilientBlocks (Ruby port of BeResilientBlocks.class.st).
#
# Stresses object allocation by building linked lists of sizes 1..iterations-1.
# Verify: evaluate(2500) == 3123750  (= Σ i for i=1..2499)

require_relative 'benchmark'
require_relative 'be_resilient_list'

class BeResilientBlocks < Benchmark
  def self.main_iterations  = 15
  def self.inner_iterations = 2500

  def inner_benchmark_loop(inner_iterations)
    _verify(_evaluate(inner_iterations), inner_iterations)
  end

  private

  def _evaluate(iterations)
    total = 0
    size  = 1
    while size < iterations
      total += BeResilientList.build(size).size
      size  += 1
    end
    total
  end

  def _verify(result, iterations)
    # Σ size for size = 1..iterations-1 (3123750 for the default 2500)
    expected = iterations * (iterations - 1) / 2
    return true if result == expected
    puts "ResilientBlocks mismatch: got #{result} expected #{expected}"
    false
  end
end
