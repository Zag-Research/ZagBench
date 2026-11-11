# ZagBench – BeMatrixInversion (Ruby port of BeMatrixInversion.class.st).

require_relative 'benchmark'
require_relative 'be_random'
require_relative 'be_matrix'

class BeMatrixInversion < Benchmark
  def self.main_iterations  = 10
  def self.inner_iterations = 250

  SIZE = 10

  def initialize
    rng    = BeRandom.new
    @source = BeMatrix.with_data(rng.make_invertable(SIZE))
  end

  def inner_benchmark_loop(inner_iterations)
    result = true
    # Always run every iteration (no short-circuit), like Java's '&'.
    inner_iterations.times { result = _multiply_inverse && result }
    result
  end

  private

  def _multiply_inverse
    inv    = @source.invert
    result = inv.multiply(@source)
    result.identity_matrix?
  end
end
