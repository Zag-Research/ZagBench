# ZagBench – BeMemoizedFibonacci (Ruby port of BeMemoizedFibonacci.class.st).
#
# Ruby's Integer is arbitrary-precision, so fib(200000) works natively.
# Cache built iteratively to avoid stack-overflow for large n.

require_relative 'benchmark'
require_relative 'be_int_map'

class BeMemoizedFibonacci < Benchmark
  def self.main_iterations  = 10
  def self.inner_iterations = 250_000

  def initialize
    @cache = BeIntMap.new   # hand-rolled, same algorithm in all ports
  end

  def fib_memo(n)
    return n if n <= 1
    hit = @cache.get(n)
    return hit if hit
    # Build bottom-up from 2 to n
    a, b = 0, 1
    (2..n).each do |i|
      a, b = b, a + b
      @cache.put(i, b)
    end
    @cache.get(n)
  end

  def inner_benchmark_loop(inner_iterations)
    result = nil
    inner_iterations.times { result = fib_memo(200_000) }
    # fib(200000) mod 1e9+7, identical in every port
    if result && result % 1_000_000_007 != 216_653_165
      puts "Fibonacci mismatch: fib(200000) mod 1e9+7 = #{result % 1_000_000_007}"
      return false
    end
    true
  end
end
