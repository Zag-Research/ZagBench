# ZagBench – Run / harness class (Ruby port of Benchmark.class.st timing logic).
#
# Hand-rolled helpers: Newton sqrt, insertion sort, quartiles.
# Only 'time' (Process.clock_gettime – no require) is used for timing.

# ---------------------------------------------------------------------------
# Hand-rolled statistics helpers
# ---------------------------------------------------------------------------

def _my_sqrt(x)
  return 0.0 if x <= 0.0
  g = x / 2.0
  200.times do
    ng   = (g + x / g) * 0.5
    diff = ng - g
    diff = -diff if diff < 0.0
    return ng if diff < 1.0e-15 * g
    g = ng
  end
  g
end

def _insertion_sort(arr)
  n = arr.length
  (1...n).each do |i|
    key = arr[i]
    j   = i - 1
    while j >= 0 && arr[j] > key
      arr[j + 1] = arr[j]
      j -= 1
    end
    arr[j + 1] = key
  end
end

def _median_of(sorted, from, to)
  len = to - from
  return 0 if len <= 0
  mid = from + len / 2
  if len.odd?
    sorted[mid]
  else
    (sorted[mid - 1] + sorted[mid]) / 2
  end
end

def _quartiles(times)
  return [0, 0, 0] if times.empty?
  n   = times.length
  s   = Array.new(n)
  n.times { |i| s[i] = times[i] }
  _insertion_sort(s)
  mid = n / 2
  med = _median_of(s, 0, n)
  return [med, med, med] if n < 2 # halves are empty
  q1 = _median_of(s, 0, mid)
  q3  = n.odd? ? _median_of(s, mid + 1, n) : _median_of(s, mid, n)
  [q1, med, q3]
end

# ---------------------------------------------------------------------------
# Benchmark name → [file, class] registry
# ---------------------------------------------------------------------------

REGISTRY = {
  'memoizedfibonacci'   => ['be_memoized_fibonacci',  'BeMemoizedFibonacci'],
  'bememoizedfibonacci' => ['be_memoized_fibonacci',  'BeMemoizedFibonacci'],
  'fannkuch'            => ['be_fannkuch',             'BeFannkuch'],
  'befannkuch'          => ['be_fannkuch',             'BeFannkuch'],
  'matrixinversion'     => ['be_matrix_inversion',     'BeMatrixInversion'],
  'bematrixinversion'   => ['be_matrix_inversion',     'BeMatrixInversion'],
  'resilientblocks'     => ['be_resilient_blocks',     'BeResilientBlocks'],
  'beresilientblocks'   => ['be_resilient_blocks',     'BeResilientBlocks'],
  'stressgc'            => ['be_stress_gc',            'BeStressGC'],
  'bestressgc'          => ['be_stress_gc',            'BeStressGC'],
  'dataframe'           => ['be_data_frame',           'BeDataFrame'],
  'bedataframe'         => ['be_data_frame',           'BeDataFrame'],
}

# ---------------------------------------------------------------------------
# Run class
# ---------------------------------------------------------------------------

class Run
  def initialize(name)
    @name             = name
    @num_iterations   = nil
    @inner_iterations = nil
    @total            = 0
    @total_sq         = 0
    @times            = []
  end

  def set_num_iterations(n)
     @num_iterations   = n
  end
  def set_inner_iterations(n)
    @inner_iterations = n
  end

  def run_benchmark
    puts "Starting #{@name} benchmark ..."
    $stdout.flush

    entry = REGISTRY[@name.downcase]
    raise "Unknown benchmark: #{@name}" unless entry

    file_name, class_name = entry
    require_relative file_name

    bench_class = Object.const_get(class_name)
    ni = @num_iterations   || bench_class.main_iterations
    ii = @inner_iterations || bench_class.inner_iterations
    @num_iterations = ni

    ni.times do
      bench = bench_class.new
      _measure(bench, ii)
    end
  end

  def print_total
    _report
  end

  private

  def _measure(bench, ii)
    start_us = (Process.clock_gettime(Process::CLOCK_MONOTONIC) * 1_000_000).to_i
    ok       = bench.inner_benchmark_loop(ii)
    end_us   = (Process.clock_gettime(Process::CLOCK_MONOTONIC) * 1_000_000).to_i

    raise "Benchmark failed with incorrect result" unless ok

    run_time  = end_us - start_us
    @times   << run_time
    @total_sq += run_time * run_time
    @total    += run_time
  end

  def _mean
    @total / @num_iterations
  end

  def _std_dev
    n    = @num_iterations
    mean = @total.to_f / n
    var  = @total_sq.to_f / n - mean * mean
    _my_sqrt(var)
  end

  def _report
    n       = @num_iterations
    mean    = _mean
    std_dev = _std_dev
    pct     = mean > 0 ? (std_dev / mean * 100.0) : 0.0
    qs      = _quartiles(@times)
    mn = mx = @times[0]
    @times.each do |t|
      mn = t if t < mn
      mx = t if t > mx
    end

    printf(
      "%s: n=%d mean: %dus stdDev: %dus (%.1f%%) min: %dus 1stQ: %dus median: %dus 3rdQ: %dus max: %dus\n",
      @name, n, mean, std_dev.to_i, pct, mn, qs[0], qs[1], qs[2], mx
    )
  end
end
